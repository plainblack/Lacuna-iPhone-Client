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
}


@property (nonatomic, retain) NSMutableDictionary *dockedShips;
@property (nonatomic, retain) NSMutableArray *ships;
@property (nonatomic, retain) NSDate *shipsUpdated;
@property (nonatomic, assign) NSInteger shipsPageNumber;
@property (nonatomic, retain) NSDecimalNumber *numShips;
@property (nonatomic, retain) NSMutableArray *travellingShips;
@property (nonatomic, retain) NSDate *travellingShipsUpdated;
@property (nonatomic, assign) NSInteger travellingShipsPageNumber;
@property (nonatomic, retain) NSDecimalNumber *numTravellingShips;
@property (nonatomic, retain) NSMutableArray *foreignShips;
@property (nonatomic, retain) NSDate *foreignShipsUpdated;
@property (nonatomic, assign) NSInteger foreignShipsPageNumber;
@property (nonatomic, retain) NSDecimalNumber *numForeignShips;


- (void)loadShipsForPage:(NSInteger)pageNumber;
- (bool)hasPreviousShipsPage;
- (bool)hasNextShipsPage;
- (void)scuttleShip:(Ship *)ship;
- (void)ship:(Ship *)ship rename:(NSString *)newName;
- (void)loadTravellingShipsForPage:(NSInteger)pageNumber;
- (bool)hasPreviousTravellingShipsPage;
- (bool)hasNextTravellingShipsPage;
- (void)loadForeignShipsForPage:(NSInteger)pageNumber;
- (bool)hasPreviousForeignShipsPage;
- (bool)hasNextForeignShipsPage;
- (void)recallShip:(Ship *)ship;


@end
