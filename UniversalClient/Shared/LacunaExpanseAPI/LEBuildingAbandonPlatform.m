//
//  LEBuildingAbandonPlatform.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/1/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingAbandonPlatform.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingAbandonPlatform


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize platformId;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl platformId:(NSString *)inPlatformId {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.platformId = inPlatformId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, self.platformId);
}


- (void)processSuccess {
	NSLog(@"abandon_platform response: %@", self.response);
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"abandon_platform";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.platformId = nil;
	[super dealloc];
}


@end
