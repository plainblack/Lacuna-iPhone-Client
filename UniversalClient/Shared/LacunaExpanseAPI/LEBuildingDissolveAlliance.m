//
//  LEBuildingDissolveAlliance.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingDissolveAlliance.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingDissolveAlliance


@synthesize buildingId;
@synthesize buildingUrl;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId);
}


- (void)processSuccess {
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"dissolve_alliance";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	[super dealloc];
}


@end
