//
//  LEBuildingDonateToStash.m
//  UniversalClient
//
//  Created by Kevin Runde on 11/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingDonateToStash.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingDonateToStash


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize donation;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl donation:(NSMutableDictionary	*)inDonation {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.donation = inDonation;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, self.donation);
}


- (void)processSuccess {
	NSMutableDictionary *result = [self.response objectForKey:@"result"];
	NSLog(@"Donate to stash result: %@", result);
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"donate_to_stash";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.donation = nil;
	[super dealloc];
}


@end
