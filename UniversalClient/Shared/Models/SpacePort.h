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
}


@property (nonatomic, retain) NSMutableDictionary *dockedShips;
@property (nonatomic, retain) NSMutableArray *ships;
@property (nonatomic, retain) NSDate *shipsUpdated;
@property (nonatomic, retain) NSMutableArray *travellingShips;
@property (nonatomic, retain) NSDate *travellingShipsUpdated;


- (void)loadShips;
- (void)loadTravellingShips;
- (void)scuttleShip:(Ship *)ship;
- (void)ship:(Ship *)ship rename:(NSString *)newName;


@end
