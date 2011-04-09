//
//  LEBuildingGetBodiesForStarInJurisdiction.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/9/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuildingGetBodiesForStarInJurisdiction.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingGetBodiesForStarInJurisdiction


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize starId;
@synthesize results;
@synthesize bodies;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl starId:(NSString *)inStarId {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
    self.starId = inStarId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId, self.starId);
	return params;
}


- (void)processSuccess {
    self.results = [self.response objectForKey:@"result"];
    self.bodies = [self.results objectForKey:@"bodies"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"get_bodies_for_star_in_jurisdiction";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
    self.starId = nil;
    self.results = nil;
    self.bodies = nil;
	[super dealloc];
}


@end
