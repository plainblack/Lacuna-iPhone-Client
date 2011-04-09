//
//  LEBuidingGetMiningPlatformsForAsteroidInJurisdiction.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/9/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuidingGetMiningPlatformsForAsteroidInJurisdiction.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuidingGetMiningPlatformsForAsteroidInJurisdiction


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize asteroidId;
@synthesize results;
@synthesize miningPlatforms;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl  asteroidId:(NSString *)inAsteroidId {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
    self.asteroidId = inAsteroidId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId, self.asteroidId);
	return params;
}


- (void)processSuccess {
    self.results = [self.response objectForKey:@"result"];
    self.miningPlatforms = [self.results objectForKey:@"platforms"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"get_mining_platforms_for_asteroid_in_jurisdiction";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
    self.asteroidId = nil;
    self.results = nil;
    self.miningPlatforms = nil;
	[super dealloc];
}


@end
