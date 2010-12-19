//
//  TempleOfTheDrajilites.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "TempleOfTheDrajilites.h"
#import "LEMacros.h"
#import "Util.h"
#import "BuildingUtil.h"
#import "LETableViewCellButton.h"
#import "LEBuildingListPlanets.h"
#import "LEBuildingViewPlanet.h"
#import "SelectPlanetToViewController.h"


@implementation TempleOfTheDrajilites


@synthesize viewablePlanets;
@synthesize planetMap;


#pragma mark -
#pragma mark NSObject Methods

- (void)dealloc {
	self.viewablePlanets = nil;
	self.planetMap = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Overriden Building Methods

- (void)generateSections {
	self.sections = _array([self generateProductionSection], _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_PLANETS]), @"rows"), [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_PLANETS:
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
		case BUILDING_ROW_VIEW_PLANETS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *viewPlanetsButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			viewPlanetsButtonCell.textLabel.text = @"View Planets";
			cell = viewPlanetsButtonCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_PLANETS:
			; //DO NOT REMOVE
			SelectPlanetToViewController *selectPlanetToViewController = [SelectPlanetToViewController create];
			selectPlanetToViewController.templeOfTheDrajilites = self;
			return selectPlanetToViewController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark -
#pragma mark Instance Methods

- (void)loadViewablePlanetsForStar:(NSString *)starId {
	[[[LEBuildingListPlanets alloc] initWithCallback:@selector(loadedViewablePlanets:) target:self buildingId:self.id buildingUrl:self.buildingUrl starId:starId] autorelease];
}


- (void)loadPlanetMap:(NSString *)planetId {
	[[[LEBuildingViewPlanet alloc] initWithCallback:@selector(loadedPlanetMap:) target:self buildingId:self.id buildingUrl:self.buildingUrl planetId:planetId] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (void)loadedViewablePlanets:(LEBuildingListPlanets *)request {
	self.viewablePlanets = request.planets;
}


- (void)loadedPlanetMap:(LEBuildingViewPlanet *)request {
	self.planetMap = request.map;
}


@end
