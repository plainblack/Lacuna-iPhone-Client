//
//  LEBuildingViewStash.m
//  UniversalClient
//
//  Created by Kevin Runde on 11/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingViewStash.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingViewStash


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize stash;
@synthesize stored;
@synthesize maxExchangeSize;
@synthesize exchangesRemainingToday;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId);
}


- (void)processSuccess {
	NSMutableDictionary *result = [self.response objectForKey:@"result"];
	self.stash = [result objectForKey:@"stash"];
	self.stored = [result objectForKey:@"stored"];
	self.maxExchangeSize = [result objectForKey:@"max_exchange_size"];
	self.exchangesRemainingToday = [result objectForKey:@"exchanges_remaining_today"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"view_stash";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.stash = nil;
	self.stored = nil;
	self.maxExchangeSize = nil;
	self.exchangesRemainingToday = nil;
	[super dealloc];
}


@end
