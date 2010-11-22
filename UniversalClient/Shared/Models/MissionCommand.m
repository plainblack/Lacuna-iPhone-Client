//
//  MissionCommand.m
//  UniversalClient
//
//  Created by Kevin Runde on 10/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "MissionCommand.h"
#import "LEMacros.h"
#import	"Util.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "Mission.h"
#import "LEBuildingGetMissions.h"
#import "LEBuildingCompleteMission.h"
#import "LEBuildingSkipMission.h"
#import "ViewMissionsController.h"


@implementation MissionCommand


@synthesize missions;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.missions = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Overriden Building Methods

- (void)parseAdditionalData:(NSDictionary *)data {
	//Nothing to do this time!
}


- (void)generateSections {
	self.sections = _array([self generateProductionSection], _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Missions", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_MISSIONS]), @"rows"), [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_MISSIONS:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		default:
			return [super tableView:tableView heightForBuildingRow:buildingRow];
			break;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	UITableViewCell *cell = nil;
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_MISSIONS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *viewMissionsButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			viewMissionsButtonCell.textLabel.text = @"View Missions";
			cell = viewMissionsButtonCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_MISSIONS:
			; //DO NOT REMOVE
			ViewMissionsController *viewMissionsController = [ViewMissionsController create];
			viewMissionsController.missionCommand = self;
			return viewMissionsController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark -
#pragma mark Instance Methods

- (void)completeMission:(Mission *)mission target:(id)target callback:(SEL)callback {
	self->completeTarget = target;
	self->completeCallback = callback;
	[[[LEBuildingCompleteMission alloc] initWithCallback:@selector(missionCompleted:) target:self buildingId:self.id buildingUrl:self.buildingUrl missionId:mission.id] autorelease];
}


- (void)loadMissions {
	[[[LEBuildingGetMissions alloc] initWithCallback:@selector(missionsLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)skipMission:(Mission *)mission target:(id)target callback:(SEL)callback {
	self->skipTarget = target;
	self->skipCallback = callback;
	[[[LEBuildingSkipMission alloc] initWithCallback:@selector(missionSkipped:) target:self buildingId:self.id buildingUrl:self.buildingUrl missionId:mission.id] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (void)missionCompleted:(LEBuildingCompleteMission *)request {
	if (![request wasError]) {
		__block Mission *completedMission = nil;
		[self.missions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
			Mission *mission = (Mission *)obj;
			if ([mission.id isEqualToString:request.missionId]) {
				completedMission = mission;
				*stop = YES;
			}
		}];
		
		if (completedMission) {
			[self.missions removeObject:completedMission];
			self.needsRefresh = YES;
		}
	}
	
	if (self->completeTarget && self->completeCallback) {
		[self->completeTarget performSelector:self->completeCallback withObject:request];
	}
}


- (void)missionsLoaded:(LEBuildingGetMissions *)request {
	NSMutableArray *tmpMissions = [NSMutableArray arrayWithCapacity:[request.missions count]];
	for (NSDictionary *missionData in request.missions) {
		Mission *tmpMission = [[[Mission alloc] init] autorelease];
		[tmpMission parseData:missionData];
		[tmpMissions addObject:tmpMission];
	}
	
	self.missions = tmpMissions;
}


- (void)missionSkipped:(LEBuildingSkipMission *)request {
	if (![request wasError]) {
		__block Mission *skippedMission = nil;
		[self.missions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
			Mission *mission = (Mission *)obj;
			if ([mission.id isEqualToString:request.missionId]) {
				skippedMission = mission;
				*stop = YES;
			}
		}];
		
		if (skippedMission) {
			[self.missions removeObject:skippedMission];
			self.needsRefresh = YES;
		}
	}
	
	if (self->skipTarget && self->skipCallback) {
		[self->skipTarget performSelector:self->skipCallback withObject:request];
	}
}


@end
