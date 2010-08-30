//
//  ResourceCost.m
//  UniversalClient
//
//  Created by Kevin Runde on 6/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ResourceCost.h"
#import "LEMacros.h"
#import "Util.h"


@implementation ResourceCost


@synthesize energy;
@synthesize food;
@synthesize ore;
@synthesize time;
@synthesize waste;
@synthesize water;


#pragma mark -
#pragma mark NSObject Methods

- (NSString *)description {
	return [NSString stringWithFormat:@"{ energy:%@, food:%@, ore:%@, time:%@, waste:%@, water:%@ }",
			self.energy, self.food, self.ore, self.time, self.waste, self.water];
}

- (void)dealloc {
	self.energy = nil;
	self.food = nil;
	self.ore = nil;
	self.time = nil;
	self.waste = nil;
	self.water = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void) parseData:(NSDictionary *)data {
	if (data && (id)data != [NSNull null]) {
		self.energy = [Util asNumber:[data objectForKey:@"energy"]];
		self.food = [Util asNumber:[data objectForKey:@"food"]];
		self.ore = [Util asNumber:[data objectForKey:@"ore"]];
		if ([data objectForKey:@"time"]) {
			self.time = [Util asNumber:[data objectForKey:@"time"]];
		} else {
			self.time = [Util asNumber:[data objectForKey:@"seconds"]];
		}

		self.waste = [Util asNumber:[data objectForKey:@"waste"]];
		self.water = [Util asNumber:[data objectForKey:@"water"]];
	}
}


@end
