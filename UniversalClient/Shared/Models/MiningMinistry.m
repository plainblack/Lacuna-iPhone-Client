//
//  MiningMinistry.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/1/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "MiningMinistry.h"
#import "Ship.h"
#import "MiningPlatform.h"
#import "LEMacros.h"
#import "LETableViewCellButton.h"
#import "LEBuildingViewPlatforms.h"
#import "LEBuildingViewFleetShips.h"
#import "LEBuildingAbandonPlatform.h"
#import "LEBuildingAddShipToFleet.h"
#import "LEBuildingRemoveShipFromFleet.h"
#import "ViewMiningPlatformsController.h"
#import "ViewMiningFleetShipsController.h"


@implementation MiningMinistry


@synthesize platforms;
@synthesize fleetShips;


#pragma mark --
#pragma mark Object Methods

- (void)dealloc {
	self.platforms = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"platforms:%@", self.platforms];
}


#pragma mark --
#pragma mark Overriden Building Methods

- (void)tick:(NSInteger)interval {
	[super tick:interval];
}


- (void)generateSections {
	
	NSMutableDictionary *productionSection = [self generateProductionSection];
	
	NSMutableArray *actionRows = [NSMutableArray arrayWithCapacity:1];
	[actionRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_PLATFORMS]];
	[actionRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_FLEET_SHIPS]];
	
	self.sections = _array(productionSection, _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", actionRows, @"rows"), [self generateHealthSection], [self generateUpgradeSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_PLATFORMS:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_VIEW_FLEET_SHIPS:
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
		case BUILDING_ROW_VIEW_PLATFORMS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *viewPlatformsCell = [LETableViewCellButton getCellForTableView:tableView];
			viewPlatformsCell.textLabel.text = @"View Platforms";
			cell = viewPlatformsCell;
			break;
		case BUILDING_ROW_VIEW_FLEET_SHIPS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *viewFleetShipsCell = [LETableViewCellButton getCellForTableView:tableView];
			viewFleetShipsCell.textLabel.text = @"View Fleet Ships";
			cell = viewFleetShipsCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_PLATFORMS:
			; //DO NOT REMOVE
			ViewMiningPlatformsController *viewMiningPlatformsController = [ViewMiningPlatformsController create];
			viewMiningPlatformsController.miningMinistry = self;
			return viewMiningPlatformsController;
			break;
		case BUILDING_ROW_VIEW_FLEET_SHIPS:
			; //DO NOT REMOVE
			ViewMiningFleetShipsController *viewMiningFleetShipsController = [ViewMiningFleetShipsController create];
			viewMiningFleetShipsController.miningMinistry = self;
			return viewMiningFleetShipsController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark --
#pragma mark Instance Methods

- (void)loadPlatforms {
	[[[LEBuildingViewPlatforms alloc] initWithCallback:@selector(platformsLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)loadFleetShips {
	[[[LEBuildingViewFleetShips alloc] initWithCallback:@selector(fleetShipsLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)abandonPlatformAtAsteroid:(MiningPlatform *)miningPlatform {
	[[[LEBuildingAbandonPlatform alloc] initWithCallback:@selector(platformAbandoned:) target:self buildingId:self.id buildingUrl:self.buildingUrl platformId:miningPlatform.id] autorelease];
	__block MiningPlatform *foundMiningPlatform;
	
	[self.fleetShips enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		MiningPlatform *currentMiningPlatform = obj;
		if ([currentMiningPlatform.id isEqualToString:miningPlatform.id]) {
			foundMiningPlatform = currentMiningPlatform;
			*stop = YES;
		}
	}];
	
	
	if (foundMiningPlatform) {
		[self.platforms removeObject:foundMiningPlatform];
		self.needsRefresh = YES;
	}
}


- (void)addCargoShipToFleet:(Ship *)ship {
	[[[LEBuildingAddShipToFleet alloc] initWithCallback:@selector(shipAddedToFleet:) target:self buildingId:self.id buildingUrl:self.buildingUrl shipId:ship.id] autorelease];
	ship.task = @"Mining";
	self.needsRefresh = YES;
}


- (void)removeCargoShipFromFleet:(Ship *)ship {
	[[[LEBuildingRemoveShipFromFleet alloc] initWithCallback:@selector(shipRemovedFromFleet:) target:self buildingId:self.id buildingUrl:self.buildingUrl shipId:ship.id] autorelease];
	__block Ship *foundShip;
	
	[self.fleetShips enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		Ship *currentShip = obj;
		if ([currentShip.id isEqualToString:ship.id]) {
			foundShip = currentShip;
			*stop = YES;
		}
	}];
	
	
	if (foundShip) {
		[self.fleetShips removeObject:foundShip];
		self.needsRefresh = YES;
	}
}


#pragma mark --
#pragma mark Callback Methods
- (id)platformsLoaded:(LEBuildingViewPlatforms *)request {
	self.platforms = request.platforms;
	return nil;
}


- (id)fleetShipsLoaded:(LEBuildingViewFleetShips *)request {
	self.fleetShips = request.ships;
	return nil;
}


- (id)platformAbandoned:(LEBuildingAbandonPlatform *)request {
	return nil;
}


- (id)shipAddedToFleet:(LEBuildingAddShipToFleet *)request {
	return nil;
}


- (id)shipRemovedFromFleet:(LEBuildingRemoveShipFromFleet *)request {
	return nil;
}


@end
