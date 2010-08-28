//
//  LEBuildingAddShipToFleet.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/1/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingAddShipToFleet.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingAddShipToFleet


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize shipId;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl shipId:(NSString *)inShipId {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.shipId = inShipId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, self.shipId);
}


- (void)processSuccess {
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"add_cargo_ship_to_fleet";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.shipId = nil;
	[super dealloc];
}


@end
