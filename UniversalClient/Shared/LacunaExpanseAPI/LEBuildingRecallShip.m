//
//  LEBuildingRecallShip.m
//  UniversalClient
//
//  Created by Kevin Runde on 2/21/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuildingRecallShip.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingRecallShip


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize shipId;
@synthesize result;
@synthesize shipData;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl shipId:(NSString *)inShipId {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.shipId = inShipId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, self.shipId, self.name);
}


- (void)processSuccess {
	self.result = [self.response objectForKey:@"result"];
	self.shipData = [self.result objectForKey:@"ship"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"name_ship";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.shipId = nil;
	self.result = nil;
	self.shipData = nil;
	[super dealloc];
}


@end
