//
//  Security.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/14/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Security.h"
#import "LEMacros.h"
#import "LETableViewCellButton.h"
#import "LEBuildingExecutePrisoner.h"
#import "LEBuildingReleasePrisoner.h"
#import "LEBuildingViewForeignSpies.h"
#import "LEBuildingViewPrisoners.h"
#import "ViewPrisonersController.h"
#import "ViewForeignSpiesController.h"
#import "Prisoner.h"


@implementation Security


@synthesize prisoners;
@synthesize prisonersUpdated;
@synthesize foreignSpies;
@synthesize foreignSpiesUpdated;


#pragma mark --
#pragma mark Object Methods

- (void)dealloc {
	self.prisoners = nil;
	self.prisonersUpdated = nil;
	self.foreignSpies = nil;
	self.foreignSpiesUpdated = nil;
	[super dealloc];
}


#pragma mark --
#pragma mark Overriden Building Methods

- (void)tick:(NSInteger)interval {
	[super tick:interval];
	BOOL reloadPrisoners = NO;

	for (Prisoner *prisoner in self.prisoners) {
		if ([prisoner tick:interval]) {
			reloadPrisoners = YES;
		}
	}
	
	if (reloadPrisoners) {
		[self loadPrisoners];
	}
	
	self.prisonersUpdated = [NSDate date];
}


- (void)parseAdditionalData:(NSDictionary *)data {
	//Nothing to do this time!
}


- (void)generateSections {
	self.sections = _array([self generateProductionSection], _dict([NSNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", _array([NSNumber numberWithInt:BUILDING_ROW_VIEW_PRISONERS], [NSNumber numberWithInt:BUILDING_ROW_VIEW_FOREIGN_SPIES]), @"rows"), [self generateHealthSection], [self generateUpgradeSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_PRISONERS:
		case BUILDING_ROW_VIEW_FOREIGN_SPIES:
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
		case BUILDING_ROW_VIEW_PRISONERS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *viewPrisionersButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			viewPrisionersButtonCell.textLabel.text = @"View Prisoners";
			cell = viewPrisionersButtonCell;
			break;
		case BUILDING_ROW_VIEW_FOREIGN_SPIES:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *viewForeignSpiesButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			viewForeignSpiesButtonCell.textLabel.text = @"View Foreign Spies";
			cell = viewForeignSpiesButtonCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_PRISONERS:
			; //DO NOT REMOVE
			ViewPrisonersController *viewPrisonersController = [ViewPrisonersController create];
			viewPrisonersController.securityBuilding = self;
			return viewPrisonersController;
			break;
		case BUILDING_ROW_VIEW_FOREIGN_SPIES:
			; //DO NOT REMOVE
			ViewForeignSpiesController *viewForeignSpiesController = [ViewForeignSpiesController create];
			viewForeignSpiesController.securityBuilding = self;
			return viewForeignSpiesController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark --
#pragma mark Instance Methods

- (void)loadPrisoners {
	[[[LEBuildingViewPrisoners alloc] initWithCallback:@selector(pisonersLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl pageNumber:0] autorelease];
}


- (void)loadForeignSpies {
	[[[LEBuildingViewForeignSpies alloc] initWithCallback:@selector(foreignSpiesLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl pageNumber:0] autorelease];
}


- (void)executePrisoner:(NSString *)prisonerId {
	[[[LEBuildingExecutePrisoner alloc] initWithCallback:@selector(executedPrisoner:) target:self buildingId:self.id buildingUrl:self.buildingUrl prisonerId:prisonerId] autorelease];
}


- (void)releasePrisoner:(NSString *)prisonerId {
	[[[LEBuildingReleasePrisoner alloc] initWithCallback:@selector(releasedPrisoner:) target:self buildingId:self.id buildingUrl:self.buildingUrl prisonerId:prisonerId] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (id)pisonersLoaded:(LEBuildingViewPrisoners *)request {
	NSMutableArray *tmpPrisoners = [NSMutableArray arrayWithCapacity:[request.prisoners count]];
	for (NSDictionary *prisonerData in request.prisoners) {
		Prisoner *tmpPrisoner = [[[Prisoner alloc] init] autorelease];
		[tmpPrisoner parseData:prisonerData];
		[tmpPrisoners addObject:tmpPrisoner];
	}
	
	self.prisoners = tmpPrisoners;
	self.prisonersUpdated = [NSDate date];
	return nil;
}

- (id)foreignSpiesLoaded:(LEBuildingViewForeignSpies *)request {
	self.foreignSpies = request.foreignSpies;
	self.foreignSpiesUpdated = [NSDate date];
	return nil;
}

- (id)executedPrisoner:(LEBuildingExecutePrisoner *)request {
	__block Prisoner *foundPrisoner;
	
	[self.prisoners enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		Prisoner *currentPrisoner = obj;
		if ([currentPrisoner.id isEqualToString:request.prisonerId]) {
			foundPrisoner = currentPrisoner;
			*stop = YES;
		}
	}];
	
	if (foundPrisoner) {
		[self.prisoners removeObject:foundPrisoner];
		self.prisonersUpdated = [NSDate date];
	}
	
	return nil;
}


- (id)releasedPrisoner:(LEBuildingReleasePrisoner *)request {
	__block Prisoner *foundPrisoner;
	
	[self.prisoners enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		Prisoner *currentPrisoner = obj;
		if ([currentPrisoner.id isEqualToString:request.prisonerId]) {
			foundPrisoner = currentPrisoner;
			*stop = YES;
		}
	}];
	
	
	if (foundPrisoner) {
		[self.prisoners removeObject:foundPrisoner];
		self.prisonersUpdated = [NSDate date];
	}
	
	return nil;
}


@end
