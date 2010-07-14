//
//  PlanetaryCommand.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/14/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import	"Building.h"


@interface PlanetaryCommand : Building {
	NSNumber *nextColonyCost;
}


@property (nonatomic, retain) NSNumber *nextColonyCost;


@end
