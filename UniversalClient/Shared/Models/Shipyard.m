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
#import "MapBuilding.h"
#import "LEBuildingViewShipBuildQueue.h"
#import "LEBuildingGetBuildableShips.h"
#import "LEBuildingBuildShip.h"
#import	"LEBuildingSubsidizeBuildQueue.h"
#import "LETableViewCellButton.h"
#import "ViewShipBuildQueueController.h"
#import "BuildShipTypeController.h"


@implementation Shipyard


@synthesize buildQueue;
@synthesize buildableShips;
@synthesize docksAvailable;
@synthesize buildQueuePageNumber;
@synthesize numBuildQueue;
@synthesize subsidizeCost;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.buildQueue = nil;
	self.buildableShips = nil;
	self.docksAvailable = nil;
	self.numBuildQueue = nil;
    self.subsidizeCost = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"buildQueue:%@, buildableShips:%@", self.buildQueue, self.buildableShips];
}


#pragma mark -
#pragma mark Overriden Building Methods

- (void)generateSections {
	
	NSMutableDictionary *productionSection = [self generateProductionSection];
	
	NSMutableArray *actionRows = [NSMutableArray arrayWithCapacity:1];
	[actionRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_SHIP_BUILD_QUEUE]];
	[actionRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_BUILD_SHIP]];
	
	self.sections = _array(productionSection, _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", actionRows, @"rows"), [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
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
			BuildShipTypeController *buildShipTypeController = [BuildShipTypeController create];
			buildShipTypeController.shipyard = self;
			return buildShipTypeController;
			return nil;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark - Instance Methods

- (void)loadBuildQueueForPage:(NSInteger)pageNumber {
	self.buildQueuePageNumber = pageNumber;
	[[[LEBuildingViewShipBuildQueue alloc] initWithCallback:@selector(buildQueueLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl pageNumber:pageNumber] autorelease];
}


- (void)loadBuildableShipsForType:(NSString *)type {
	[[[LEBuildingGetBuildableShips alloc] initWithCallback:@selector(buildableShipsLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl type:type] autorelease];
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

- (void)subsidizeBuildQueue {
    [[[LEBuildingSubsidizeBuildQueue alloc] initWithCallback:@selector(subsidizedBuildQueue:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (void)buildQueueLoaded:(LEBuildingViewShipBuildQueue *)request {
	self.buildQueue = request.shipBuildQueue;
	self.numBuildQueue = request.numberShipBuilding;
    self.subsidizeCost = request.subsidizeBuildCost;
}


- (void)buildableShipsLoaded:(LEBuildingGetBuildableShips *)request {
	self.docksAvailable = request.docksAvailable;
	self.buildableShips = request.buildableShips;
}


- (void)shipBuildQueued:(LEBuildingBuildShip *)request {
	self.buildQueue = request.shipBuildQueue;
	self.numBuildQueue = request.numberShipBuilding;
    self.subsidizeCost = request.subsidizeBuildCost;
	[self parseWorkData:request.workData];
	[[self findMapBuilding] updateWork:request.workData];
	self.needsRefresh = YES;
}


- (void)subsidizedBuildQueue:(LEBuildingSubsidizeBuildQueue *)request {
	[self parseData:request.result];
	[[self findMapBuilding] parseData:[request.result objectForKey:@"building"]];
    self.buildQueue = [NSMutableArray array];
    self.numBuildQueue = [NSDecimalNumber zero];
    self.subsidizeCost = [NSDecimalNumber zero];
	self.needsRefresh = YES;
}


@end
