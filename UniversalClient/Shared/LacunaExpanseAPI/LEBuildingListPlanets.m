//
//  LEBuildingListPlanets.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingListPlanets.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingListPlanets


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize starId;
@synthesize planets;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl starId:(NSString *)inStarId {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.starId = inStarId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, self.starId);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.planets = [result objectForKey:@"planets"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"list_planets";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.starId = nil;
	self.planets = nil;
	[super dealloc];
}



@end
