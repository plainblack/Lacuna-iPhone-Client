//
//  ResourceCost.m
//  UniversalClient
//
//  Created by Kevin Runde on 6/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ResourceCost.h"
#import "LEMacros.h"


@implementation ResourceCost


@synthesize energy;
@synthesize food;
@synthesize ore;
@synthesize time;
@synthesize waste;
@synthesize water;


#pragma mark --
#pragma mark NSObject Methods

- (NSString *)description {
	return [NSString stringWithFormat:@"{ energy:%i, food:%i, ore:%i, time:%i, waste:%i, water: %i }",
			self.energy, self.food, self.ore, self.time, self.waste, self.water];
}


#pragma mark --
#pragma mark Instance Methods

- (void) parseData:(NSDictionary *)data {
	if (data && (id)data != [NSNull null]) {
		self.energy = _intv([data objectForKey:@"energy"]);
		self.food = _intv([data objectForKey:@"food"]);
		self.ore = _intv([data objectForKey:@"ore"]);
		if ([data objectForKey:@"time"]) {
			self.time = _intv([data objectForKey:@"time"]);
		} else {
			self.time = _intv([data objectForKey:@"seconds"]);
		}

		self.waste = _intv([data objectForKey:@"waste"]);
		self.water = _intv([data objectForKey:@"water"]);
	}
}


@end
