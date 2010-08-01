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
	NSMutableArray *buildQueue;
	NSMutableArray *buildableShips;
	NSInteger docksAvailable;
}


@property (nonatomic, retain) NSMutableArray *buildQueue;
@property (nonatomic, retain) NSMutableArray *buildableShips;
@property (nonatomic, assign) NSInteger docksAvailable;


- (void)loadBuildQueue;
- (void)loadBuildableShips;
- (void)buildShipOfType:(NSString *)shipType;


@end
