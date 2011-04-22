//
//  Shipyard.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@interface Shipyard : Building {
}


@property (nonatomic, retain) NSMutableArray *buildQueue;
@property (nonatomic, retain) NSMutableArray *buildableShips;
@property (nonatomic, retain) NSDecimalNumber *docksAvailable;
@property (nonatomic, assign) NSInteger buildQueuePageNumber;
@property (nonatomic, retain) NSDecimalNumber *numBuildQueue;
@property (nonatomic, retain) NSDecimalNumber *subsidizeCost;


- (void)loadBuildQueueForPage:(NSInteger)pageNumber;
- (void)loadBuildableShipsForType:(NSString *)type;
- (void)buildShipOfType:(NSString *)shipType;
- (bool)hasPreviousBuildQueuePage;
- (bool)hasNextBuildQueuePage;
- (void)subsidizeBuildQueue;


@end
