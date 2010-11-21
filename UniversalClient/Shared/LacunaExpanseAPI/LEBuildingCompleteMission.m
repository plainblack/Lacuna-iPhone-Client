//
//  LEBuildingCompleteMission.m
//  UniversalClient
//
//  Created by Kevin Runde on 11/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingCompleteMission.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingCompleteMission


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize missionId;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl missionId:(NSString *)inMissionId {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.missionId = inMissionId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, self.missionId);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"complete_mission";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.missionId = nil;
	[super dealloc];
}


@end
