//
//  TempleOfTheDrajilites.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import	"Building.h"


@interface TempleOfTheDrajilites : Building {
	NSMutableArray *viewablePlanets;
	NSMutableDictionary *planetMap;
}


@property (nonatomic, retain) NSMutableArray *viewablePlanets;
@property (nonatomic, retain) NSMutableDictionary *planetMap;


- (void)loadViewablePlanets;
- (void)loadPlanetMap:(NSString *)planetId;


@end