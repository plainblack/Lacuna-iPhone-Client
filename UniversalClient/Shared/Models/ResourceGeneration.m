//
//  BuildingResources.m
//  UniversalClient
//
//  Created by Kevin Runde on 6/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ResourceGeneration.h"
#import "LEMacros.h"
#import "Util.h"


@implementation ResourceGeneration


@synthesize energy;
@synthesize food;
@synthesize happiness;
@synthesize ore;
@synthesize waste;
@synthesize water;


#pragma mark -
#pragma mark NSObject Methods

- (NSString *)description {
	return [NSString stringWithFormat:@"{ energy:%@, food:%@, happiness:%@, ore:%@, waste:%@, water:%@ }",
			self.energy, self.food, self.happiness, self.ore, self.waste, self.water];
}


- (void)dealloc {
	self.energy = nil;
	self.food = nil;
	self.happiness = nil;
	self.ore = nil;
	self.waste = nil;
	self.water = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void) parseData:(NSDictionary *)data {
	if (data && (id)data != [NSNull null]) {
		self.energy = [Util asNumber:[data objectForKey:@"energy_hour"]];
		self.food = [Util asNumber:[data objectForKey:@"food_hour"]];
		self.happiness = [Util asNumber:[data objectForKey:@"happiness_hour"]];
		self.ore = [Util asNumber:[data objectForKey:@"ore_hour"]];
		self.waste = [Util asNumber:[data objectForKey:@"waste_hour"]];
		self.water = [Util asNumber:[data objectForKey:@"water_hour"]];
	}

}


@end
