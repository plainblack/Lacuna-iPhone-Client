//
//  Shipyard.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Shipyard.h"
#import "LEMacros.h"
#import "Util.h"
#import "LEBuildingViewShipBuildQueue.h"
#import "LEBuildingGetBuildableShips.h"
#import "LEBuildingBuildShip.h"
#import "LETableViewCellButton.h"
#import "ViewShipBuildQueueController.h"
#import "BuildShipController.h"


@implementation Shipyard


@synthesize buildQueue;
@synthesize buildableShips;
@synthesize docksAvailable;
@synthesize buildQueuePageNumber;
@synthesize numBuildQueue;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.buildQueue = nil;
	self.buildableShips = nil;
	self.docksAvailable = nil;
	self.numBuildQueue = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"buildQueue:%@, buildableShips:%@", self.buildQueue, self.buildableShips];
}


#pragma mark -
#pragma mark Overriden Building Methods

- (void)tick:(NSInteger)interval {
	[super tick:interval];
}


- (void)generateSections {
	
	NSMutableDictionary *productionSection = [self generateProductionSection];
	
	NSMutableArray *actionRows = [NSMutableArray arrayWithCapacity:1];
	[actionRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_SHIP_BUILD_QUEUE]];
	[actionRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_BUILD_SHIP]];
	
	self.sections = _array(productionSection, _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", actionRows, @"rows"), [self generateHealthSection], [self generateUpgradeSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_SHIP_BUILD_QUEUE:
		case BUILDING_ROW_BUILD_SHIP:
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
		case BUILDING_ROW_VIEW_SHIP_BUILD_QUEUE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *viewShipBuildQueueCell = [LETableViewCellButton getCellForTableView:tableView];
			viewShipBuildQueueCell.textLabel.text = @"View Build Queue";
			cell = viewShipBuildQueueCell;
			break;
		case BUILDING_ROW_BUILD_SHIP:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *buildShipCell = [LETableViewCellButton getCellForTableView:tableView];
			buildShipCell.textLabel.text = @"Build Ship";
			cell = buildShipCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_SHIP_BUILD_QUEUE:
			; //DO NOT REMOVE
			ViewShipBuildQueueController *viewShipBuildQueueController = [ViewShipBuildQueueController create];
			viewShipBuildQueueController.shipyard = self;
			return viewShipBuildQueueController;
			break;
		case BUILDING_ROW_BUILD_SHIP:
			; //DO NOT REMOVE
			BuildShipController *buildShipController = [BuildShipController create];
			buildShipController.shipyard = self;
			return buildShipController;
			return nil;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark -
#pragma mark Instance Methods

- (void)loadBuildQueueForPage:(NSInteger)pageNumber {
	self.buildQueuePageNumber = pageNumber;
	[[[LEBuildingViewShipBuildQueue alloc] initWithCallback:@selector(buildQueueLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl pageNumber:pageNumber] autorelease];
}


- (void)loadBuildableShips {
	[[[LEBuildingGetBuildableShips alloc] initWithCallback:@selector(buildableShipsLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)buildShipOfType:(NSString *)shipType {
	[[[LEBuildingBuildShip alloc] initWithCallback:@selector(shipBuildQueued:) target:self buildingId:self.id buildingUrl:self.buildingUrl shipType:shipType] autorelease];
}


- (bool)hasPreviousBuildQueuePage {
	return (self.buildQueuePageNumber > 1);
}


- (bool)hasNextBuildQueuePage {
	return (self.buildQueuePageNumber < [Util numPagesForCount:_intv(self.numBuildQueue)]);
}


#pragma mark -
#pragma mark Callback Methods

- (id)buildQueueLoaded:(LEBuildingViewShipBuildQueue *)request {
	self.buildQueue = request.shipBuildQueue;
	self.numBuildQueue = request.numberShipBuilding;
	return nil;
}


- (id)buildableShipsLoaded:(LEBuildingGetBuildableShips *)request {
	self.docksAvailable = request.docksAvailable;
	self.buildableShips = request.buildableShips;
	return nil;
}


- (id)shipBuildQueued:(LEBuildingBuildShip *)request {
	self.buildQueue = request.shipBuildQueue;
	return nil;
}

@end
