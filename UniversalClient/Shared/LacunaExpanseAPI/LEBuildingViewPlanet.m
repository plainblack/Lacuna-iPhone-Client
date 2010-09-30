//
//  LEBuildingViewPlanet.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingViewPlanet.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingViewPlanet


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize planetId;
@synthesize map;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl planetId:(NSString *)inPlanetId {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.planetId = inPlanetId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, self.planetId);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.map = [result objectForKey:@"map"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"view_planet";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.planetId = nil;
	self.map = nil;
	[super dealloc];
}



@end
