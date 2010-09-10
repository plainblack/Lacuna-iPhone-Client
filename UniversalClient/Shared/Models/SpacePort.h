//
//  SpacePort.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@class Ship;


@interface SpacePort : Building {
	NSMutableDictionary *dockedShips;
	NSMutableArray *ships;
	NSDate *shipsUpdated;
	NSMutableArray *travellingShips;
	NSDate *travellingShipsUpdated;
	NSInteger travellingShipsPageNumber;
	NSDecimalNumber *numTravellingShips;
}


@property (nonatomic, retain) NSMutableDictionary *dockedShips;
@property (nonatomic, retain) NSMutableArray *ships;
@property (nonatomic, retain) NSDate *shipsUpdated;
@property (nonatomic, retain) NSMutableArray *travellingShips;
@property (nonatomic, retain) NSDate *travellingShipsUpdated;
@property (nonatomic, assign) NSInteger travellingShipsPageNumber;
@property (nonatomic, retain) NSDecimalNumber *numTravellingShips;


- (void)loadShips;
- (void)loadTravellingShipsForPage:(NSInteger)pageNumber;
- (void)scuttleShip:(Ship *)ship;
- (void)ship:(Ship *)ship rename:(NSString *)newName;
- (bool)hasPreviousTravellingShipsPage;
- (bool)hasNextTravellingShipsPage;


@end
