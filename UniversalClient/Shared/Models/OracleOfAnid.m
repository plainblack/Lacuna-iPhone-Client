//
//  OracleOfAnid.m
//  UniversalClient
//
//  Created by Kevin Runde on 12/23/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "OracleOfAnid.h"
#import "LEMacros.h"
#import "Util.h"
#import "BuildingUtil.h"
#import "Star.h"
#import "Body.h"
#import "LETableViewCellButton.h"
#import "LEBuildingListPlanets.h"
#import "LEBuildingViewPlanet.h"
#import "LEBuildingGetStar.h"
#import "SelectStarToViewController.h"


@implementation OracleOfAnid


@synthesize star;
@synthesize bodies;


#pragma mark -
#pragma mark NSObject Methods

- (void)dealloc {
	self.star = nil;
	self.bodies = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Overriden Building Methods

- (void)generateSections {
	self.sections = _array([self generateProductionSection], _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_STAR]), @"rows"), [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_STAR:
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
		case BUILDING_ROW_VIEW_STAR:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *viewStarButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			viewStarButtonCell.textLabel.text = @"View Star";
			cell = viewStarButtonCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_STAR:
			; //DO NOT REMOVE
			SelectStarToViewController *selectStarToViewController = [SelectStarToViewController create];
			selectStarToViewController.oracleOfAnid = self;
			return selectStarToViewController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark -
#pragma mark Instance Methods

- (void)loadStar:(NSString *)starId {
	[[[LEBuildingGetStar alloc] initWithCallback:@selector(loadedStar:) target:self buildingId:self.id buildingUrl:self.buildingUrl starId:starId] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (void)loadedStar:(LEBuildingGetStar *)request {
	Star *tmpStar = [[Star alloc] init];
	[tmpStar parseData:request.star];
	
	NSMutableArray *bodiesData = [request.star objectForKey:@"bodies"];
	NSMutableArray *tmpBodies = [NSMutableArray arrayWithCapacity:[bodiesData count]];
	[bodiesData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		Body *tmpBody = [[Body alloc] init];
		[tmpBody parseData:obj];
		[tmpBodies addObject:tmpBody];
		[tmpBody release];
	}];
	
	self.bodies = tmpBodies;
	self.star = tmpStar;
	[tmpStar release];
}


@end
