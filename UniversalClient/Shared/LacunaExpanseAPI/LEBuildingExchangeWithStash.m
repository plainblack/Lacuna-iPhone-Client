//
//  LEBuildingExchangeWithStash.m
//  UniversalClient
//
//  Created by Kevin Runde on 11/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingExchangeWithStash.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingExchangeWithStash


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize donation;
@synthesize request;
@synthesize stash;
@synthesize stored;
@synthesize maxExchangeSize;
@synthesize exchangesRemainingToday;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl donation:(NSMutableDictionary *)inDonation request:(NSMutableDictionary *)inRequest {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.donation = inDonation;
	self.request = inRequest;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, self.donation, self.request);
}


- (void)processSuccess {
	NSMutableDictionary *result = [self.response objectForKey:@"result"];
	id tmp = [result objectForKey:@"stash"];
	if (isNotNull(tmp)) {
		self.stash = tmp;
	} else {
		self.stash = [NSMutableDictionary dictionary];
	}
	
	self.stored = [result objectForKey:@"stored"];
	self.maxExchangeSize = [result objectForKey:@"max_exchange_size"];
	self.exchangesRemainingToday = [result objectForKey:@"exchanges_remaining_today"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"exchange_with_stash";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.donation = nil;
	self.request = nil;
	self.stash = nil;
	self.stored = nil;
	self.maxExchangeSize = nil;
	self.exchangesRemainingToday = nil;
	[super dealloc];
}


@end
