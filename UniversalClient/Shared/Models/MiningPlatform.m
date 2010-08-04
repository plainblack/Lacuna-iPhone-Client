//
//  MiningPlatform.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/1/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "MiningPlatform.h"
#import "LEMacros.h"


@interface MiningPlatform (PrivateMethods)

- (void)add:(NSNumber *)number toDictionary:(NSMutableDictionary *)dict withKey:(NSString *)key;

@end


@implementation MiningPlatform


@synthesize id;
@synthesize asteroidId;
@synthesize asteroidName;
@synthesize oresPerHour;
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
	return [NSString stringWithFormat:@"id:%@, asteroidId:%@, asteroidName:%@, oresPerHour:%@, shippingCapacity:%i",
			self.id, self.asteroidId, self.asteroidName, self.oresPerHour, self.shippingCapacity];
}


#pragma mark --
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
	NSLog(@"Platform Data: %@", data);
	
	self.id = [data objectForKey:@"id"];
	NSDictionary *asteroidData = [data objectForKey:@"asteroid"];
	self.asteroidId = [asteroidData objectForKey:@"id"];
	self.asteroidName = [asteroidData objectForKey:@"name"];
	
	if (!self.oresPerHour) {
		self.oresPerHour = [NSMutableDictionary dictionaryWithCapacity:20];
	} else {
		[self.oresPerHour removeAllObjects];
	}
	
	[self add:[data objectForKey:@"rutile_hour"] toDictionary:self.oresPerHour withKey:@"rutile"];
	[self add:[data objectForKey:@"chromite_hour"] toDictionary:self.oresPerHour withKey:@"chromite"];
	[self add:[data objectForKey:@"chalcopyrite_hour"] toDictionary:self.oresPerHour withKey:@"chalcopyrite"];
	[self add:[data objectForKey:@"galena_hour"] toDictionary:self.oresPerHour withKey:@"galena"];
	[self add:[data objectForKey:@"gold_hour"] toDictionary:self.oresPerHour withKey:@"gold"];
	[self add:[data objectForKey:@"uraninite_hour"] toDictionary:self.oresPerHour withKey:@"uraninite"];
	[self add:[data objectForKey:@"bauxite_hour"] toDictionary:self.oresPerHour withKey:@"bauxite"];
	[self add:[data objectForKey:@"goethite_hour"] toDictionary:self.oresPerHour withKey:@"goethite"];
	[self add:[data objectForKey:@"halite_hour"] toDictionary:self.oresPerHour withKey:@"halite"];
	[self add:[data objectForKey:@"gypsum_hour"] toDictionary:self.oresPerHour withKey:@"gypsum"];
	[self add:[data objectForKey:@"trona_hour"] toDictionary:self.oresPerHour withKey:@"trona"];
	[self add:[data objectForKey:@"kerogen_hour"] toDictionary:self.oresPerHour withKey:@"kerogen"];
	[self add:[data objectForKey:@"methane_hour"] toDictionary:self.oresPerHour withKey:@"methane"];
	[self add:[data objectForKey:@"anthracite_hour"] toDictionary:self.oresPerHour withKey:@"anthracite"];
	[self add:[data objectForKey:@"sulfur_hour"] toDictionary:self.oresPerHour withKey:@"sulfur"];
	[self add:[data objectForKey:@"zircon_hour"] toDictionary:self.oresPerHour withKey:@"zircon"];
	[self add:[data objectForKey:@"monazite_hour"] toDictionary:self.oresPerHour withKey:@"monazite"];
	[self add:[data objectForKey:@"fluorite_hour"] toDictionary:self.oresPerHour withKey:@"fluorite"];
	[self add:[data objectForKey:@"beryl_hour"] toDictionary:self.oresPerHour withKey:@"beryl"];
	[self add:[data objectForKey:@"magnetite_hour"] toDictionary:self.oresPerHour withKey:@"magnetite"];

	self.shippingCapacity = _intv([data objectForKey:@"shipping_capacity"]);
}


#pragma mark --
#pragma mark Private Methods

- (void)add:(NSNumber *)number toDictionary:(NSMutableDictionary *)dict withKey:(NSString *)key {
	if (_intv(number) > 0) {
		[dict setObject:number forKey:key];
	}
}


@end
