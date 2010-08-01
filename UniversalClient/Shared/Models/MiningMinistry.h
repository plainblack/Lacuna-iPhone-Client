//
//  MiningMinistry.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/1/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@interface MiningMinistry : Building {
	NSMutableArray *platforms;
	NSMutableArray *fleetShips;
}


@property (nonatomic, retain) NSMutableArray *platforms;
@property (nonatomic, retain) NSMutableArray *fleetShips;


- (void)loadPlatforms;
- (void)loadFleetShips;
- (void)abandonPlatformAtAsteroid:(NSString *)platformId;
- (void)addCargoShipToFleet:(NSString *)shipId;
- (void)removeCargoShipToFleet:(NSString *)shipId;


@end
