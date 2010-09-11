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
#import "Session.h"


@implementation NoLimitResource


@synthesize current;
@synthesize perHour;
@synthesize perSec;


#pragma mark -
#pragma mark NSObject Methods

- (NSString *)description {
	return [NSString stringWithFormat:@"{ current:%@, perHour:%@, perSec:%@ }",
			self.current, self.perHour, self.perSec];
}


- (void)dealloc {
	self.current = nil;
	self.perHour = nil;
	self.perSec = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)tick:(NSInteger)inInterval {
	NSDecimalNumber *interval = [Util decimalFromInt:inInterval]; 
	NSDecimalNumber *newValue = [self.current decimalNumberByAdding:[self.perSec decimalNumberByMultiplyingBy:interval]];
	Session *session = [Session sharedInstance];
	if (session.empire.isIsolationist && [newValue compare:[NSDecimalNumber zero]] == NSOrderedAscending) {
		self.current = [NSDecimalNumber zero];
	} else {
		self.current = newValue;
	}
}


- (void)addToCurrent:(NSDecimalNumber *)adjustment {
	NSDecimalNumber *newValue = [self.current decimalNumberByAdding:adjustment];
	Session *session = [Session sharedInstance];
	if (session.empire.isIsolationist && [newValue compare:[NSDecimalNumber zero]] == NSOrderedAscending) {
		self.current = [NSDecimalNumber zero];
	} else {
		self.current = newValue;
	}
}

				  
- (void)subtractFromCurrent:(NSDecimalNumber *)adjustment {
	NSDecimalNumber *newValue = [self.current decimalNumberBySubtracting:adjustment];
	Session *session = [Session sharedInstance];
	if (session.empire.isIsolationist && [newValue compare:[NSDecimalNumber zero]] == NSOrderedAscending) {
		self.current = [NSDecimalNumber zero];
	} else {
		self.current = newValue;
	}
}


- (void)parseFromData:(NSDictionary *)data withPrefix:(NSString *)prefix{
	self.current = [Util asNumber:[data objectForKey:[NSString stringWithFormat:@"%@", prefix]]];
	self.perHour = [Util asNumber:[data objectForKey:[NSString stringWithFormat:@"%@_hour", prefix]]];
	self.perSec = [self.perHour decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"3600"]];
}


@end
