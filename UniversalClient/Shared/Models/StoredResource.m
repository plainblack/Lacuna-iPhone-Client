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
@synthesize lastTick;


#pragma mark --
#pragma mark NSObject Methods

- (void)dealloc {
	self.current = nil;
	self.perSec = nil;
	self.lastTick = nil;
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


#pragma mark --
#pragma mark Class Methods

+ (StoredResource *)createFromData:(NSDictionary *)data withPrefix:(NSString *)prefix {
	StoredResource *resource = [[[StoredResource alloc] init] autorelease];
	
	resource.current = [data objectForKey:[NSString stringWithFormat:@"%@_stored", prefix]];
	NSString *tmp = [NSString stringWithFormat:@"%@_capacity", prefix];
	resource.max = _intv([data objectForKey:tmp]);
	tmp = [NSString stringWithFormat:@"%@_hour", prefix];
	resource.perHour = _intv([data objectForKey:tmp]);
	resource.perSec = [NSNumber numberWithFloat:resource.perHour / SEC_IN_HOUR];
	resource.lastTick = [NSDate date];
	
	return resource;
}


@end
