//
//  LEBuildingProposeFireBfg.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/9/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuildingProposeFireBfg.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingProposeFireBfg


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize bodyId;
@synthesize reason;
@synthesize results;
@synthesize proposition;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl bodyId:(NSString *)inBodyId reason:(NSString *)inReason {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
    self.bodyId = inBodyId;
    self.reason = inReason;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId, self.bodyId, self.reason);
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
	return @"propose_fire_bfg";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
    self.bodyId = nil;
    self.reason = nil;
    self.results = nil;
    self.proposition = nil;
	[super dealloc];
}


@end
