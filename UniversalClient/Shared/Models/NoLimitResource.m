//
//  NoLimitResource.m
//  UniversalClient
//
//  Created by Kevin Runde on 6/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "NoLimitResource.h"
#import "LEMacros.h"
#import "Util.h"


@implementation NoLimitResource


@synthesize current;
@synthesize perHour;
@synthesize perSec;


#pragma mark --
#pragma mark NSObject Methods

- (NSString *)description {
	return [NSString stringWithFormat:@"{ current:%@, perHour:%i, perSec:%@ }",
			self.current, self.perHour, self.perSec];
}


- (void)dealloc {
	self.current = nil;
	self.perHour = nil;
	self.perSec = nil;
	[super dealloc];
}


#pragma mark --
#pragma mark Instance Methods

- (void)tick:(NSInteger)inInterval {
	NSDecimalNumber *interval = [Util decimalFromInt:inInterval]; 
	self.current = [self.current decimalNumberByAdding:[self.perSec decimalNumberByMultiplyingBy:interval]];
}


- (void)addToCurrent:(NSDecimalNumber *)adjustment {
	self.current = [self.current decimalNumberByAdding:adjustment];
}

				  
- (void)subtractFromCurrent:(NSDecimalNumber *)adjustment {
	self.current = [self.current decimalNumberBySubtracting:adjustment];
}


- (void)parseFromData:(NSDictionary *)data withPrefix:(NSString *)prefix{
	
	self.current = [Util asNumber:[data objectForKey:[NSString stringWithFormat:@"%@", prefix]]];
	self.perHour = [Util asNumber:[data objectForKey:[NSString stringWithFormat:@"%@_hour", prefix]]];
	self.perSec = [self.perHour decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"3600"]];
}


@end
