//
//  LEBuildingProposeEvictMiningPlatform.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/9/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuildingProposeEvictMiningPlatform.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingProposeEvictMiningPlatform


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize miningPlatformId;
@synthesize results;
@synthesize proposition;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl miningPlatformId:(NSString *)inMiningPlatformId {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
    self.miningPlatformId = inMiningPlatformId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId, self.miningPlatformId);
	return params;
}


- (void)processSuccess {
    self.results = [self.response objectForKey:@"result"];
    self.proposition = [self.results objectForKey:@"proposition"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"propose_evict_mining_platform";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
    self.miningPlatformId = nil;
    self.results = nil;
    self.proposition = nil;
	[super dealloc];
}


@end
