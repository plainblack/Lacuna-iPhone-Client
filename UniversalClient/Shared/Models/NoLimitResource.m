//
//  NoLimitResource.m
//  UniversalClient
//
//  Created by Kevin Runde on 6/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "NoLimitResource.h"
#import "LEMacros.h"


@implementation NoLimitResource


@synthesize current;
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

- (void)tick:(NSInteger)interval {
	double tmp = ([self.current doubleValue] + ([self.perSec doubleValue] * interval));
	self.current = [NSNumber numberWithDouble:tmp];
}


- (void)addToCurrent:(NSNumber *)adjustment {
	double tmp = ([self.current doubleValue] + [adjustment doubleValue]);
	self.current = [NSNumber numberWithDouble:tmp];
}

				  
- (void)subtractFromCurrent:(NSNumber *)adjustment {
	double tmp = ([self.current doubleValue] - [adjustment doubleValue]);
	self.current = [NSNumber numberWithDouble:tmp];
}



#pragma mark --
#pragma mark Class Methods

+ (NoLimitResource *)createFromData:(NSDictionary *)data withPrefix:(NSString *)prefix{
	NoLimitResource *resource = [[[NoLimitResource alloc] init] autorelease];
	
	NSNumberFormatter *f = [[[NSNumberFormatter alloc] init] autorelease];
	[f setNumberStyle:NSNumberFormatterDecimalStyle];
	resource.current = [f numberFromString:[data objectForKey:[NSString stringWithFormat:@"%@", prefix]]];
	resource.perHour = [[f numberFromString:[data objectForKey:[NSString stringWithFormat:@"%@_hour", prefix]]] intValue];
	resource.perSec = [NSNumber numberWithFloat:resource.perHour / SEC_IN_HOUR];
	resource.lastTick = [NSDate date];

	return resource;
}


@end
