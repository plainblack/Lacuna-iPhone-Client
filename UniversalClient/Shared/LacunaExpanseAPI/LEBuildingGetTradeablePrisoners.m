//
//  LEGetTradeablePrisoners.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingGetTradeablePrisoners.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingGetTradeablePrisoners


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize prisoners;
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
	
	
	self.prisoners = [result objectForKey:@"prisoners"];
	self.cargoSpaceUsedPer = [Util asNumber:[result objectForKey:@"cargo_space_used_each"]];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"get_prisoners";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.prisoners = nil;
	self.cargoSpaceUsedPer = nil;
	[super dealloc];
}


@end
