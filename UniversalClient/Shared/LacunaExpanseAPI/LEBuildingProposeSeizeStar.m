//
//  LEBuildingProposeSeizeStar.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/9/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuildingProposeSeizeStar.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingProposeSeizeStar


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize starId;
@synthesize results;
@synthesize proposition;


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
    self.proposition = [self.results objectForKey:@"proposition"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"propose_seize_star";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
    self.starId = nil;
    self.results = nil;
    self.proposition = nil;
	[super dealloc];
}


@end
