//
//  LEBuildingGetTradeableSpies.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/24/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuildingGetTradeableSpies.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingGetTradeableSpies


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize spies;
@synthesize cargoSpaceUsedPer;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
    NSLog(@"Get Spies Result: %@", result);
	self.spies = [result objectForKey:@"spies"];
	self.cargoSpaceUsedPer = [Util asNumber:[result objectForKey:@"cargo_space_used_each"]];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"get_spies";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.spies = nil;
	self.cargoSpaceUsedPer = nil;
	[super dealloc];
}


@end
