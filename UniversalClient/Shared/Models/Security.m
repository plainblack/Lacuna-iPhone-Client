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
#import "LEBuildingViewPrisoners.h"
#import "ViewPrisonersController.h"
#import "Prisoner.h"


@implementation Security

@synthesize prisoners;
@synthesize prisonersUpdated;


#pragma mark --
#pragma mark Object Methods

- (void)dealloc {
	self.prisoners = nil;
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
	self.sections = _array([self generateProductionSection], [self generateHealthSection], _dict([NSNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", _array([NSNumber numberWithInt:BUILDING_ROW_VIEW_PRISONERS]), @"rows"), [self generateUpgradeSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_PRISONERS:
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


@end
