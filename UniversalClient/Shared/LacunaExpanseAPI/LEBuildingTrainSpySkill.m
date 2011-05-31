//
//  LEBuildingTrainSpySkill.m
//  UniversalClient
//
//  Created by Kevin Runde on 5/30/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuildingTrainSpySkill.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingTrainSpySkill


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize spyId;
@synthesize results;
@synthesize notTrained;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl spyId:(NSString *)inSpyId {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
    self.spyId = inSpyId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId, self.spyId);
	return params;
}


- (void)processSuccess {
    self.results = [self.response objectForKey:@"result"];
    self.notTrained = [Util asNumber:[self.results objectForKey:@""]];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"train_spy";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
    self.spyId = nil;
    self.results = nil;
    self.notTrained = nil;
	[super dealloc];
}


@end
