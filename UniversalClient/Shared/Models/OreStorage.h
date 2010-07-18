//
//  OreStorage.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@interface OreStorage : Building {
	NSMutableDictionary *storedOre;
}


@property (nonatomic, retain) NSMutableDictionary *storedOre;


@end
