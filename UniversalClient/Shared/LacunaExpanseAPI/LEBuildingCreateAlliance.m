//
//  LEBuildingCreateAlliance.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingCreateAlliance.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingCreateAlliance


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize name;
@synthesize allianceStatus;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl name:(NSString *)inName {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.name = inName;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, self.name);
}


- (void)processSuccess {
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"accept_trade";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.name = nil;
	self.allianceStatus = nil;
	[super dealloc];
}


@end
