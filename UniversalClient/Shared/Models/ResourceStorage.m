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
	return [NSString stringWithFormat:@"{ energy:%@, food:%@, ore:%i, waste:%i, water: %i }",
			self.energy, self.food, self.ore, self.waste, self.water];
}


#pragma mark --
#pragma mark Instance Methods

- (void) parseData:(NSDictionary *)data {
	if (data && (id)data != [NSNull null]) {
		self.energy = intv_([data objectForKey:@"%energy_hour"]);
		self.food = intv_([data objectForKey:@"%food_hour"]);
		self.ore = intv_([data objectForKey:@"%ore_hour"]);
		self.waste = intv_([data objectForKey:@"%waste_hour"]);
		self.water = intv_([data objectForKey:@"%water_hour"]);
	}
}


@end
