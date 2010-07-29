//
//  LEBuildingScuttleShip.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingScuttleShip.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingScuttleShip


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
	//Does nothing
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"scuttle_ship";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.shipId = nil;
	[super dealloc];
}


@end
