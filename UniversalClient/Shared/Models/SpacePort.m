//
//  SpacePort.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "SpacePort.h"
#import "Ship.h"
#import "LEMacros.h"
#import "Util.h"
#import "LEBuildingViewAllShips.h"
#import "LEBuildingNameShip.h"
#import "LEBuildingScuttleShip.h"
#import "LEBuildingViewShipsTravelling.h"
#import "LEBuildingViewForeignShips.h"
#import "LEBuildingRecallShip.h"
#import "LETableViewCellButton.h"
#import "ViewDictionaryController.h"
#import "ViewShipsByTypeController.h"
#import "ViewTravellingShipsController.h"
#import "ViewForeignShipsController.h"


@implementation SpacePort


@synthesize dockedShips;
@synthesize ships;
@synthesize shipsUpdated;
@synthesize numShips;
@synthesize travellingShips;
@synthesize travellingShipsUpdated;
@synthesize travellingShipsPageNumber;
@synthesize numTravellingShips;
@synthesize foreignShips;
@synthesize foreignShipsUpdated;
@synthesize foreignShipsPageNumber;
@synthesize numForeignShips;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.dockedShips = nil;
	self.ships = nil;
	self.shipsUpdated = nil;
	self.numShips = nil;
	self.travellingShips = nil;
	self.travellingShipsUpdated = nil;
	self.numTravellingShips = nil;
	self.foreignShips = nil;
	self.foreignShipsUpdated = nil;
	self.numForeignShips = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"docked_ships:%@", self.dockedShips];
}


#pragma mark -
#pragma mark Overriden Building Methods

- (void)parseAdditionalData:(NSDictionary *)data {
	NSDictionary *dockedShipData = [data objectForKey:@"docked_ships"];
	self.dockedShips = [NSMutableDictionary dictionaryWithCapacity:[dockedShipData count]];
	
	[dockedShipData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		[self.dockedShips setObject:obj forKey:[Util prettyCodeValue:key]];
	}];
}


- (void)generateSections {
	
	NSMutableArray *localShipRows = [NSMutableArray arrayWithCapacity:1];
	[localShipRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_DOCKED_SHIPS]];
	[localShipRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_TRAVELLING_SHIPS]];
	[localShipRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_SHIPS]];
	
	NSMutableArray *foreignShipRows = [NSMutableArray arrayWithCapacity:1];
	[foreignShipRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_FOREIGN_SHIPS]];
	
	self.sections = _array([self generateProductionSection],
						   _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_LOCAL_SHIPS], @"type", @"Local Ships", @"name", localShipRows, @"rows"), 
						   _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_FOREIGN_SHIPS], @"type", @"Incoming Ships", @"name", foreignShipRows, @"rows"), 
						   [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_DOCKED_SHIPS:
		case BUILDING_ROW_VIEW_TRAVELLING_SHIPS:
		case BUILDING_ROW_VIEW_SHIPS:
		case BUILDING_ROW_VIEW_FOREIGN_SHIPS:
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
		case BUILDING_ROW_DOCKED_SHIPS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *dockedShipsCell = [LETableViewCellButton getCellForTableView:tableView];
			dockedShipsCell.textLabel.text = @"Docked Ship Count";
			cell = dockedShipsCell;
			break;
		case BUILDING_ROW_VIEW_SHIPS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *viewShipsCell = [LETableViewCellButton getCellForTableView:tableView];
			viewShipsCell.textLabel.text = @"View Ships";
			cell = viewShipsCell;
			break;
		case BUILDING_ROW_VIEW_TRAVELLING_SHIPS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *viewTravellingShipsCell = [LETableViewCellButton getCellForTableView:tableView];
			viewTravellingShipsCell.textLabel.text = @"Ships In Transit";
			cell = viewTravellingShipsCell;
			break;
		case BUILDING_ROW_VIEW_FOREIGN_SHIPS:
			; //DO NOT REMOVE THIS!!
			LETableViewCellButton *viewForeignShipsCell = [LETableViewCellButton getCellForTableView:tableView];
			viewForeignShipsCell.textLabel.text = @"View Incoming Ships";
			cell = viewForeignShipsCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_DOCKED_SHIPS:
			; //DO NOT REMOVE
			ViewDictionaryController *viewDictionaryController = [ViewDictionaryController createWithName:@"Docked Ship Count" useLongLabels:YES icon:nil];
			viewDictionaryController.data = self.dockedShips;
			return viewDictionaryController;
			break;
		case BUILDING_ROW_VIEW_SHIPS:
			; //DO NOT REMOVE
			ViewShipsByTypeController *viewShipsByTypeController = [ViewShipsByTypeController create];
			viewShipsByTypeController.spaceport = self;
			return viewShipsByTypeController;
			break;
		case BUILDING_ROW_VIEW_TRAVELLING_SHIPS:
			; //DO NOT REMOVE
			ViewTravellingShipsController *viewTravellingShipsController = [ViewTravellingShipsController create];
			viewTravellingShipsController.spacePort = self;
			return viewTravellingShipsController;
			break;
		case BUILDING_ROW_VIEW_FOREIGN_SHIPS:
			; //DO NOT REMOVE
			ViewForeignShipsController *viewForeignShipsController = [ViewForeignShipsController create];
			viewForeignShipsController.spacePort = self;
			return viewForeignShipsController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark -
#pragma mark Instance Methods

- (void)loadShipsForTag:(NSString *)tag task:(NSString *)task {
	[[[LEBuildingViewAllShips alloc] initWithCallback:@selector(shipsLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl tag:tag task:task] autorelease];
}


- (void)scuttleShip:(Ship *)ship {
	[[[LEBuildingScuttleShip alloc] initWithCallback:@selector(shipScuttled:) target:self buildingId:self.id buildingUrl:self.buildingUrl shipId:ship.id] autorelease];
}


- (void)ship:(Ship *)ship rename:(NSString *)newName {
	[[[LEBuildingNameShip alloc] initWithCallback:@selector(shipRenamed:) target:self buildingId:self.id buildingUrl:self.buildingUrl shipId:ship.id name:newName] autorelease];
}


- (void)loadTravellingShipsForPage:(NSInteger)pageNumber {
	self.travellingShipsPageNumber = pageNumber;
	[[[LEBuildingViewShipsTravelling alloc] initWithCallback:@selector(travellingShipsLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl pageNumber:pageNumber] autorelease];
}


- (bool)hasPreviousTravellingShipsPage {
	return (self.travellingShipsPageNumber > 1);
}


- (bool)hasNextTravellingShipsPage {
	return (self.travellingShipsPageNumber < [Util numPagesForCount:_intv(self.numTravellingShips)]);
}


- (void)loadForeignShipsForPage:(NSInteger)pageNumber {
	self.foreignShipsPageNumber = pageNumber;
	[[[LEBuildingViewForeignShips alloc] initWithCallback:@selector(foreignShipsLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl pageNumber:pageNumber] autorelease];
}


- (bool)hasPreviousForeignShipsPage {
	return (self.foreignShipsPageNumber > 1);
}


- (bool)hasNextForeignShipsPage {
	return (self.foreignShipsPageNumber < [Util numPagesForCount:_intv(self.numForeignShips)]);
}

- (void)recallShip:(Ship *)ship {
	[[[LEBuildingRecallShip alloc] initWithCallback:@selector(shipRecalled:) target:self buildingId:self.id buildingUrl:self.buildingUrl shipId:ship.id] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (void)shipsLoaded:(LEBuildingViewAllShips *)request {
	self.ships = request.ships;
	self.numShips = request.numberOfShips;
	self.shipsUpdated = [NSDate date];
}


- (void)shipScuttled:(LEBuildingScuttleShip *)request {
	Ship *shipToRemove = nil;
	for (Ship *newShip in self.ships) {
		if ([newShip.id isEqualToString:request.shipId]) {
			shipToRemove = newShip;
		}
	}
	if (shipToRemove) {
		[self.ships removeObject:shipToRemove];
	}
	
	self.shipsUpdated = [NSDate date];
}


- (void)shipRenamed:(LEBuildingNameShip *)request {
	Ship *renamedShip;
	for (Ship *ship in self.ships) {
		if ([ship.id isEqualToString:request.shipId]) {
			renamedShip = ship;
		}
	}
	
	renamedShip.name = request.name;
	self.shipsUpdated = [NSDate date];
}


- (void)travellingShipsLoaded:(LEBuildingViewShipsTravelling *)request {
	self.travellingShips = request.travellingShips;
	self.numTravellingShips = request.numberOfShipsTravelling;
	self.travellingShipsUpdated = [NSDate date];
}


- (void)foreignShipsLoaded:(LEBuildingViewForeignShips *)request {
	self.foreignShips = request.foreignShips;
	self.numForeignShips = request.numberOfShipsForeign;
	self.foreignShipsUpdated = [NSDate date];
}


- (void)shipRecalled:(LEBuildingRecallShip *)request {
	Ship *recalledShip = nil;
	for (Ship *ship in self.ships) {
		if ([ship.id isEqualToString:request.shipId]) {
			recalledShip = ship;
		}
	}
	
	[recalledShip parseData:request.shipData];
	self.shipsUpdated = [NSDate date];
}


@end
