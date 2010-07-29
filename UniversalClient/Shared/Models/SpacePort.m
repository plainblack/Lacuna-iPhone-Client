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
#import "LETableViewCellButton.h"
#import "LETableViewCellDictionary.h"
#import "LEBuildingViewAllShips.h"
#import "ViewShipsController.h"
#import "LEBuildingNameShip.h"
#import "LEBuildingScuttleShip.h"


@implementation SpacePort


@synthesize dockedShips;
@synthesize ships;
@synthesize shipsUpdated;


#pragma mark --
#pragma mark Object Methods

- (void)dealloc {
	self.dockedShips = nil;
	self.ships = nil;
	self.shipsUpdated = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"docked_ships:%@", self.dockedShips];
}


#pragma mark --
#pragma mark Overriden Building Methods

- (void)tick:(NSInteger)interval {
	[super tick:interval];
}


- (void)parseAdditionalData:(NSDictionary *)data {
	self.dockedShips = [data objectForKey:@"docked_ships"];
	NSLog(@"Docked Ships: %@", self.dockedShips);
}


- (void)generateSections {
	
	NSMutableDictionary *productionSection = [self generateProductionSection];
	[[productionSection objectForKey:@"rows"] addObject:[NSNumber numberWithInt:BUILDING_ROW_DOCKED_SHIPS]];

	NSMutableArray *actionRows = [NSMutableArray arrayWithCapacity:1];
	[actionRows addObject:[NSNumber numberWithInt:BUILDING_ROW_VIEW_SHIPS]];
	
	self.sections = _array(productionSection, _dict([NSNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", actionRows, @"rows"), [self generateUpgradeSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_DOCKED_SHIPS:
			return [LETableViewCellDictionary getHeightForTableView:tableView numItems:[self.dockedShips count]];
			break;
		case BUILDING_ROW_VIEW_SHIPS:
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
			LETableViewCellDictionary *dockedShipsCell = [LETableViewCellDictionary getCellForTableView:tableView];
			[dockedShipsCell setHeading:@"Docked Ships" Data:self.dockedShips];
			cell = dockedShipsCell;
			break;
		case BUILDING_ROW_VIEW_SHIPS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *buttonCell = [LETableViewCellButton getCellForTableView:tableView];
			buttonCell.textLabel.text = @"View Ships";
			cell = buttonCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_SHIPS:
			; //DO NOT REMOVE
			ViewShipsController *viewShipsController = [ViewShipsController create];
			viewShipsController.spacePort = self;
			return viewShipsController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark --
#pragma mark Instance Methods

- (void)loadShips {
	[[[LEBuildingViewAllShips alloc] initWithCallback:@selector(shipsLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)scuttleShip:(Ship *)ship {
	[[[LEBuildingScuttleShip alloc] initWithCallback:@selector(shipScuttled:) target:self buildingId:self.id buildingUrl:self.buildingUrl shipId:ship.id] autorelease];
}


- (void)ship:(Ship *)ship rename:(NSString *)newName {
	[[[LEBuildingNameShip alloc] initWithCallback:@selector(shipRenamed:) target:self buildingId:self.id buildingUrl:self.buildingUrl shipId:ship.id name:newName] autorelease];
}


#pragma mark --
#pragma mark Callback Methods

- (id)shipsLoaded:(LEBuildingViewAllShips *)request {
	self.ships = request.ships;
	self.shipsUpdated = [NSDate date];
	return nil;
}


- (id)shipScuttled:(LEBuildingScuttleShip *)request {
	Ship *shipToRemove;
	for (Ship *newShip in self.ships) {
		if ([newShip.id isEqualToString:request.shipId]) {
			shipToRemove = newShip;
		}
	}
	if (shipToRemove) {
		[self.ships removeObject:shipToRemove];
	}
	
	self.shipsUpdated = [NSDate date];
	return nil;
}


- (id)shipRenamed:(LEBuildingNameShip *)request {
	Ship *renamedShip;
	for (Ship *ship in self.ships) {
		if ([ship.id isEqualToString:request.shipId]) {
			renamedShip = ship;
		}
	}
	
	renamedShip.name = request.name;
	self.shipsUpdated = [NSDate date];
	return nil;
}


@end
