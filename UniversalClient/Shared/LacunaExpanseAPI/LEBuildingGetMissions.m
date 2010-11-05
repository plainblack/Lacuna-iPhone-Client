//
//  LEBuildingGetMissions.m
//  UniversalClient
//
//  Created by Kevin Runde on 11/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingGetMissions.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingGetMissions


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize missions;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.missions = [result objectForKey:@"missions"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"get_missions";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.missions = nil;
	[super dealloc];
}


@end
