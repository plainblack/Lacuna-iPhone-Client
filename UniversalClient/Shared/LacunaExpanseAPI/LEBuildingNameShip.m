//
//  LEBuildingNameShip.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingNameShip.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingNameShip


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize shipId;
@synthesize name;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl shipId:(NSString *)inShipId name:(NSString *)inName {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.shipId = inShipId;
	self.name = inName;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, self.shipId, self.name);
}


- (void)processSuccess {
	//Does nothing
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
	self.name = nil;
	[super dealloc];
}


@end
