//
//  ResourceStorage.m
//  UniversalClient
//
//  Created by Kevin Runde on 6/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ResourceStorage.h"
#import "LEMacros.h"
#import "Util.h"


@implementation ResourceStorage


@synthesize energy;
@synthesize food;
@synthesize ore;
@synthesize waste;
@synthesize water;
@synthesize hasStorage;


#pragma mark --
#pragma mark NSObject Methods

- (NSString *)description {
	return [NSString stringWithFormat:@"{ energy:%@, food:%@, ore:%@, waste:%@, water:%@ }",
			self.energy, self.food, self.ore, self.waste, self.water];
}


- (void)dealloc {
	self.energy = nil;
	self.food = nil;
	self.ore = nil;
	self.waste = nil;
	self.water = nil;
	[super dealloc];
}


#pragma mark --
#pragma mark Instance Methods

- (void) parseData:(NSDictionary *)data {
	if (data && (id)data != [NSNull null]) {
		self.energy = [Util asNumber:[data objectForKey:@"energy_capacity"]];
		self.food = [Util asNumber:[data objectForKey:@"food_capacity"]];
		self.ore = [Util asNumber:[data objectForKey:@"ore_capacity"]];
		self.waste = [Util asNumber:[data objectForKey:@"waste_capacity"]];
		self.water = [Util asNumber:[data objectForKey:@"water_capacity"]];
		self.hasStorage = (_intv(self.energy) != 0) || (_intv(self.food) != 0) || (_intv(self.ore) != 0) || (_intv(self.waste) != 0) || (_intv(self.water) != 0);
	} else {
		self.hasStorage = NO;
	}


}


@end
