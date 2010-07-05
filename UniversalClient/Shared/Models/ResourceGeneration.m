//
//  BuildingResources.m
//  UniversalClient
//
//  Created by Kevin Runde on 6/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ResourceGeneration.h"
#import "LEMacros.h"


@implementation ResourceGeneration


@synthesize energy;
@synthesize food;
@synthesize happiness;
@synthesize ore;
@synthesize waste;
@synthesize water;


#pragma mark --
#pragma mark NSObject Methods

- (NSString *)description {
	return [NSString stringWithFormat:@"{ energy:%i, food:%i, happiness:%i, ore:%i, waste:%i, water: %i }",
			self.energy, self.food, self.happiness, self.ore, self.waste, self.water];
}


#pragma mark --
#pragma mark Instance Methods

- (void) parseData:(NSDictionary *)data {
	if (data && (id)data != [NSNull null]) {
		self.energy = _intv([data objectForKey:@"energy_hour"]);
		self.food = _intv([data objectForKey:@"food_hour"]);
		self.happiness = _intv([data objectForKey:@"happiness_hour"]);
		self.ore = _intv([data objectForKey:@"ore_hour"]);
		self.waste = _intv([data objectForKey:@"waste_hour"]);
		self.water = _intv([data objectForKey:@"water_hour"]);
	}

}


@end
