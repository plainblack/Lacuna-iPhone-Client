//
//  StoredResource.m
//  UniversalClient
//
//  Created by Kevin Runde on 6/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "StoredResource.h"
#import "LEMacros.h"


@implementation StoredResource


@synthesize current;
@synthesize max;
@synthesize perHour;
@synthesize perSec;


#pragma mark --
#pragma mark NSObject Methods

- (NSString *)description {
	return [NSString stringWithFormat:@"{ current:%@, max:%i, perHour:%i, perSec:%@ }",
			self.current, self.max, self.perHour, self.perSec];
}


- (void)dealloc {
	self.current = nil;
	self.perSec = nil;
	[super dealloc];
}


#pragma mark --
#pragma mark Instance Methods

- (NSNumber *)tick:(NSInteger)interval {
	double generated = ([self.current doubleValue] + ([self.perSec doubleValue] * interval));
	if (generated > self.max) {
		self.current = [NSNumber numberWithInt:self.max];
		return [NSNumber numberWithDouble:(generated - self.max)];
	} else {
		self.current = [NSNumber numberWithDouble:generated];
		return nil;
	}
}


- (void)parseFromData:(NSDictionary *)data withPrefix:(NSString *)prefix {
	self.current = [data objectForKey:[NSString stringWithFormat:@"%@_stored", prefix]];
	NSString *tmp = [NSString stringWithFormat:@"%@_capacity", prefix];
	self.max = _intv([data objectForKey:tmp]);
	tmp = [NSString stringWithFormat:@"%@_hour", prefix];
	self.perHour = _intv([data objectForKey:tmp]);
	self.perSec = [NSNumber numberWithFloat:((CGFloat)self.perHour / SEC_IN_HOUR)];
}


@end
