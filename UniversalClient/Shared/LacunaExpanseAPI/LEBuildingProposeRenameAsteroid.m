//
//  LEBuildingProposeRenameAsteroid.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/9/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuildingProposeRenameAsteroid.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingProposeRenameAsteroid


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize asteroidId;
@synthesize name;
@synthesize results;
@synthesize proposition;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl asteroidId:(NSString *)inAsteroidId name:(NSString *)inName {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
    self.asteroidId = inAsteroidId;
    self.name = inName;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId, self.asteroidId, self.name);
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
	return @"propose_rename_asteroid";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.asteroidId = nil;
	self.name = nil;
    self.results = nil;
    self.proposition = nil;
	[super dealloc];
}


@end
