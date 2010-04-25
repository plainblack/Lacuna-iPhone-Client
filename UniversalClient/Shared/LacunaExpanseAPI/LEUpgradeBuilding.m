//
//  LEUpgradeBuilding.m
//  DKTest
//
//  Created by Kevin Runde on 3/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LEUpgradeBuilding.h"
#import "Session.h"
#import "LEMacros.h"


@implementation LEUpgradeBuilding


@synthesize buildingId;
@synthesize buildingUrl;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return array_([Session sharedInstance].sessionId, self.buildingId);
}


- (void)processSuccess {
	//Does nothing
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"upgrade";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	[super dealloc];
}


@end
