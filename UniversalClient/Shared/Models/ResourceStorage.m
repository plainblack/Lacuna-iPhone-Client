//
//  ResourceStorage.m
//  UniversalClient
//
//  Created by Kevin Runde on 6/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ResourceStorage.h"
#import "LEMacros.h"


@implementation ResourceStorage


@synthesize energy;
@synthesize food;
@synthesize ore;
@synthesize waste;
@synthesize water;


#pragma mark --
#pragma mark NSObject Methods

- (NSString *)description {
	return [NSString stringWithFormat:@"{ energy:%i, food:%i, ore:%i, waste:%i, water: %i }",
			self.energy, self.food, self.ore, self.waste, self.water];
}


#pragma mark --
#pragma mark Instance Methods

- (void) parseData:(NSDictionary *)data {
	if (data && (id)data != [NSNull null]) {
		self.energy = _intv([data objectForKey:@"energy_capacity"]);
		self.food = _intv([data objectForKey:@"food_capacity"]);
		self.ore = _intv([data objectForKey:@"ore_capacity"]);
		self.waste = _intv([data objectForKey:@"waste_capacity"]);
		self.water = _intv([data objectForKey:@"water_capacity"]);
	}
}


@end
