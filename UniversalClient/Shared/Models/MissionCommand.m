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
			viewMissionsButtonCell.textLabel.text = @"Comming Soon";
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
			/*
			ViewPrisonersController *viewPrisonersController = [ViewPrisonersController create];
			viewPrisonersController.securityBuilding = self;
			return viewPrisonersController;
			 */
			return nil;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark -
#pragma mark Instance Methods

- (void)loadMissions {
	NSLog(@"Kevin Load Missions here");
}


#pragma mark -
#pragma mark Callback Methods
/*
- (id)missionsLoaded:(LEBuildingViewPrisoners *)request {
	NSMutableArray *tmpPrisoners = [NSMutableArray arrayWithCapacity:[request.prisoners count]];
	for (NSDictionary *prisonerData in request.prisoners) {
		Prisoner *tmpPrisoner = [[[Prisoner alloc] init] autorelease];
		[tmpPrisoner parseData:prisonerData];
		[tmpPrisoners addObject:tmpPrisoner];
	}
	
	self.prisoners = tmpPrisoners;
	self.numPrisoners = request.numberPrisoners;
	self.prisonersUpdated = [NSDate date];
	return nil;
}
*/

@end
