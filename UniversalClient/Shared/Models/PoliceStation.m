//
//  PoliceStation.m
//  UniversalClient
//
//  Created by Kevin Runde on 5/8/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "PoliceStation.h"
#import "LEMacros.h"
#import	"Util.h"
#import "LETableViewCellButton.h"
#import "LEBuildingExecutePrisoner.h"
#import "LEBuildingReleasePrisoner.h"
#import "LEBuildingViewForeignSpies.h"
#import "LEBuildingViewPrisoners.h"
#import "ViewPrisonersController.h"
#import "ViewForeignSpiesController.h"
#import "Prisoner.h"
#import "LEBuildingViewShipsTravelling.h"
#import "LEBuildingViewForeignShips.h"
#import "LEBuildingViewShipsOrbiting.h"
#import "ViewTravellingShipsController.h"
#import "ViewForeignShipsController.h"
#import "ViewShipsOrbitingController.h"


@implementation PoliceStation


@synthesize prisoners;
@synthesize prisonersUpdated;
@synthesize foreignSpies;
@synthesize foreignSpiesUpdated;
@synthesize prisonersPageNumber;
@synthesize foreignSpyPageNumber;
@synthesize numPrisoners;
@synthesize numForeignSpy;
@synthesize travellingShips;
@synthesize travellingShipsUpdated;
@synthesize travellingShipsPageNumber;
@synthesize numTravellingShips;
@synthesize foreignShips;
@synthesize foreignShipsUpdated;
@synthesize foreignShipsPageNumber;
@synthesize numForeignShips;
@synthesize orbitingShips;
@synthesize orbitingShipsUpdated;
@synthesize orbitingShipsPageNumber;
@synthesize numOrbitingShips;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.prisoners = nil;
	self.prisonersUpdated = nil;
	self.foreignSpies = nil;
	self.foreignSpiesUpdated = nil;
	self.numPrisoners = nil;
	self.numForeignSpy = nil;
	self.travellingShips = nil;
	self.travellingShipsUpdated = nil;
	self.numTravellingShips = nil;
	self.foreignShips = nil;
	self.foreignShipsUpdated = nil;
	self.numForeignShips = nil;
    self.orbitingShips = nil;
    self.orbitingShipsUpdated = nil;
    self.numOrbitingShips = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Overriden Building Methods

- (BOOL)tick:(NSInteger)interval {
	BOOL reloadPrisoners = NO;
    
	for (Prisoner *prisoner in self.prisoners) {
		if ([prisoner tick:interval]) {
			reloadPrisoners = YES;
		}
	}
	
	if (reloadPrisoners) {
		[self loadPrisonersForPage:self.prisonersPageNumber];
	}
	
	self.prisonersUpdated = [NSDate date];
	return [super tick:interval];
}


- (void)parseAdditionalData:(NSDictionary *)data {
	//Nothing to do this time!
}


- (void)generateSections {
	self.sections = _array([self generateProductionSection], _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_PRISONERS], [NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_FOREIGN_SPIES], [NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_TRAVELLING_SHIPS], [NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_FOREIGN_SHIPS], [NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_ORBITING_SHIPS]), @"rows"), [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_PRISONERS:
		case BUILDING_ROW_VIEW_FOREIGN_SPIES:
		case BUILDING_ROW_VIEW_TRAVELLING_SHIPS:
		case BUILDING_ROW_VIEW_FOREIGN_SHIPS:
		case BUILDING_ROW_VIEW_ORBITING_SHIPS:
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
		case BUILDING_ROW_VIEW_ORBITING_SHIPS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *viewOrbitingShipsButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			viewOrbitingShipsButtonCell.textLabel.text = @"View Orbiting Ships";
			cell = viewOrbitingShipsButtonCell;
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
			viewPrisonersController.spySecurityBuilding = self;
			return viewPrisonersController;
			break;
		case BUILDING_ROW_VIEW_FOREIGN_SPIES:
			; //DO NOT REMOVE
			ViewForeignSpiesController *viewForeignSpiesController = [ViewForeignSpiesController create];
			viewForeignSpiesController.spySecurityBuilding = self;
			return viewForeignSpiesController;
			break;
		case BUILDING_ROW_VIEW_TRAVELLING_SHIPS:
			; //DO NOT REMOVE
			ViewTravellingShipsController *viewTravellingShipsController = [ViewTravellingShipsController create];
			viewTravellingShipsController.shipIntel = self;
			return viewTravellingShipsController;
			break;
		case BUILDING_ROW_VIEW_FOREIGN_SHIPS:
			; //DO NOT REMOVE
			ViewForeignShipsController *viewForeignShipsController = [ViewForeignShipsController create];
			viewForeignShipsController.shipIntel = self;
			return viewForeignShipsController;
			break;
		case BUILDING_ROW_VIEW_ORBITING_SHIPS:
			; //DO NOT REMOVE
			ViewShipsOrbitingController *viewShipsOrbitingController = [ViewShipsOrbitingController create];
			viewShipsOrbitingController.shipIntel = self;
			return viewShipsOrbitingController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark -
#pragma mark Instance Methods

- (void)loadPrisonersForPage:(NSInteger)pageNumber {
	self.prisonersPageNumber = pageNumber;
	[[[LEBuildingViewPrisoners alloc] initWithCallback:@selector(pisonersLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl pageNumber:pageNumber] autorelease];
}


- (void)loadForeignSpiesForPage:(NSInteger)pageNumber {
	self.foreignSpyPageNumber = pageNumber;
	[[[LEBuildingViewForeignSpies alloc] initWithCallback:@selector(foreignSpiesLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl pageNumber:pageNumber] autorelease];
}


- (void)executePrisoner:(NSString *)prisonerId {
	[[[LEBuildingExecutePrisoner alloc] initWithCallback:@selector(executedPrisoner:) target:self buildingId:self.id buildingUrl:self.buildingUrl prisonerId:prisonerId] autorelease];
}


- (void)releasePrisoner:(NSString *)prisonerId {
	[[[LEBuildingReleasePrisoner alloc] initWithCallback:@selector(releasedPrisoner:) target:self buildingId:self.id buildingUrl:self.buildingUrl prisonerId:prisonerId] autorelease];
}

- (bool)hasPreviousPrisonersPage {
	return (self.prisonersPageNumber > 1);
}


- (bool)hasNextPrisonersPage {
	return (self.prisonersPageNumber < [Util numPagesForCount:_intv(self.numPrisoners)]);
}


- (bool)hasPreviousForeignSpyPage {
	return (self.foreignSpyPageNumber > 1);
}


- (bool)hasNextForeignSpyPage {
	return (self.foreignSpyPageNumber < [Util numPagesForCount:_intv(self.numForeignSpy)]);
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

- (void)loadOrbitingShipsForPage:(NSInteger)pageNumber {
	self.orbitingShipsPageNumber = pageNumber;
	[[[LEBuildingViewShipsOrbiting alloc] initWithCallback:@selector(orbitingShipsLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl pageNumber:pageNumber] autorelease];
}


- (bool)hasPreviousOrbitingShipsPage {
	return (self.orbitingShipsPageNumber > 1);
}


- (bool)hasNextOrbitingShipsPage {
	return (self.orbitingShipsPageNumber < [Util numPagesForCount:_intv(self.numOrbitingShips)]);
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
	self.numPrisoners = request.numberPrisoners;
	self.prisonersUpdated = [NSDate date];
	return nil;
}


- (id)foreignSpiesLoaded:(LEBuildingViewForeignSpies *)request {
	self.foreignSpies = request.foreignSpies;
	self.numForeignSpy = request.numberForeignSpies;
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


- (void)foreignShipsLoaded:(LEBuildingViewForeignShips *)request {
	self.foreignShips = request.foreignShips;
	self.numForeignShips = request.numberOfShipsForeign;
	self.foreignShipsUpdated = [NSDate date];
}


- (void)orbitingShipsLoaded:(LEBuildingViewShipsOrbiting *)request {
	self.orbitingShips = request.orbitingShips;
	self.numOrbitingShips = request.numberOfShipsOrbiting;
	self.orbitingShipsUpdated = [NSDate date];
}


@end
