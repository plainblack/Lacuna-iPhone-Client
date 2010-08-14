//
//  StoredResource.m
//  UniversalClient
//
//  Created by Kevin Runde on 6/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "StoredResource.h"
#import "LEMacros.h"
#import "Util.h"


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
	self.max = nil;
	self.perHour = nil;
	self.perSec = nil;
	[super dealloc];
}


#pragma mark --
#pragma mark Instance Methods

- (NSDecimalNumber *)tick:(NSInteger)inInterval {
	NSDecimalNumber *interval = [Util decimalFromInt:inInterval];
	NSDecimalNumber *generated = [self.current decimalNumberByAdding:[self.perSec decimalNumberByMultiplyingBy:interval]];
	
	if ([generated compare:self.max] == NSOrderedDescending) {
		self.current = self.max;
		return [generated decimalNumberBySubtracting:self.max];
	} else {
		self.current = generated;
		return nil;
	}
}


- (void)parseFromData:(NSDictionary *)data withPrefix:(NSString *)prefix {
	self.current = [Util asNumber:[data objectForKey:[NSString stringWithFormat:@"%@_stored", prefix]]];
	self.max = [Util asNumber:[data objectForKey:[NSString stringWithFormat:@"%@_capacity", prefix]]];
	self.perHour = [Util asNumber:[data objectForKey:[NSString stringWithFormat:@"%@_hour", prefix]]];
	self.perSec = [self.perHour decimalNumberByDividingBy:[Util decimalFromInt:SEC_IN_HOUR]];
}


@end
