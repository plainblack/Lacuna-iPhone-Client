//
//  SpacePort.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@interface SpacePort : Building {
	NSMutableDictionary *dockedShips;
}


@property (nonatomic, retain) NSMutableDictionary *dockedShips;


- (void)loadShips;


@end
