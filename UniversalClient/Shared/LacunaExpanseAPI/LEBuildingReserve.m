//
//  LEBuildingReserve.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/16/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuildingReserve.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingReserve


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize resources;
@synthesize result;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl resources:(NSMutableArray *)inResources {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.resources = inResources;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId, self.resources);
	return params;
}


- (void)processSuccess {
	self.result = [self.response objectForKey:@"result"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"reserve";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.resources = nil;
    self.result = nil;
	[super dealloc];
}


@end
