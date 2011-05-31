//
//  SpacePort.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"
#import "ShipIntel.h"


@class Ship;


@interface SpacePort : Building <ShipIntel> {
}


@property (nonatomic, retain) NSMutableDictionary *dockedShips;
@property (nonatomic, retain) NSMutableArray *ships;
@property (nonatomic, retain) NSDate *shipsUpdated;
@property (nonatomic, retain) NSDecimalNumber *numShips;


- (void)loadShipsForTag:(NSString *)tag task:(NSString *)task;
- (void)scuttleShip:(Ship *)ship;
- (void)ship:(Ship *)ship rename:(NSString *)newName;
- (void)recallShip:(Ship *)ship;


@end
