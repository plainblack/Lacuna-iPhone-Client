//
//  MiningPlatform.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/1/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "MiningPlatform.h"
#import "LEMacros.h"


@implementation MiningPlatform


@synthesize id;
@synthesize asteroidId;
@synthesize asteroidName;
@synthesize oresPerHour;
@synthesize productionCapacity;
@synthesize shippingCapacity;


#pragma mark --
#pragma mark Object Methods

- (void)dealloc {
	self.id = nil;
	self.asteroidId = nil;
	self.asteroidName = nil;
	self.oresPerHour = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, asteroidId:%@, asteroidName:%@, oresPerHour:%@, productionCapacity:%i shippingCapacity:%i",
			self.id, self.asteroidId, self.asteroidName, self.oresPerHour, self.productionCapacity, self.shippingCapacity];
}


#pragma mark --
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
	self.id = [data objectForKey:@"id"];
	NSDictionary *asteroidData = [data objectForKey:@"asteroid"];
	self.asteroidId = [asteroidData objectForKey:@"id"];
	self.asteroidName = [asteroidData objectForKey:@"name"];
	
	if (!self.oresPerHour) {
		self.oresPerHour = [NSMutableDictionary dictionaryWithCapacity:20];
	} else {
		[self.oresPerHour removeAllObjects];
	}
	
	[self.oresPerHour setObject:[data objectForKey:@"rutile_hour"] forKey:@"rutile"];
	[self.oresPerHour setObject:[data objectForKey:@"chromite_hour"] forKey:@"chromite"];
	[self.oresPerHour setObject:[data objectForKey:@"chalcopyrite_hour"] forKey:@"chalcopyrite"];
	[self.oresPerHour setObject:[data objectForKey:@"galena_hour"] forKey:@"galena"];
	[self.oresPerHour setObject:[data objectForKey:@"gold_hour"] forKey:@"gold"];
	[self.oresPerHour setObject:[data objectForKey:@"uraninite_hour"] forKey:@"uraninite"];
	[self.oresPerHour setObject:[data objectForKey:@"bauxite_hour"] forKey:@"bauxite"];
	[self.oresPerHour setObject:[data objectForKey:@"goethite_hour"] forKey:@"goethite"];
	[self.oresPerHour setObject:[data objectForKey:@"halite_hour"] forKey:@"halite"];
	[self.oresPerHour setObject:[data objectForKey:@"gypsum_hour"] forKey:@"gypsum"];
	[self.oresPerHour setObject:[data objectForKey:@"trona_hour"] forKey:@"trona"];
	[self.oresPerHour setObject:[data objectForKey:@"kerogen_hour"] forKey:@"kerogen"];
	[self.oresPerHour setObject:[data objectForKey:@"methane_hour"] forKey:@"methane"];
	[self.oresPerHour setObject:[data objectForKey:@"anthracite_hour"] forKey:@"anthracite"];
	[self.oresPerHour setObject:[data objectForKey:@"sulfur_hour"] forKey:@"sulfur"];
	[self.oresPerHour setObject:[data objectForKey:@"zircon_hour"] forKey:@"zircon"];
	[self.oresPerHour setObject:[data objectForKey:@"monazite_hour"] forKey:@"monazite"];
	[self.oresPerHour setObject:[data objectForKey:@"fluorite_hour"] forKey:@"fluorite"];
	[self.oresPerHour setObject:[data objectForKey:@"beryl_hour"] forKey:@"beryl"];
	[self.oresPerHour setObject:[data objectForKey:@"magnetite_hour"] forKey:@"magnetite"];

	
	self.productionCapacity = _intv([data objectForKey:@"y"]);
	self.shippingCapacity = _intv([data objectForKey:@"z"]);
}


@end
