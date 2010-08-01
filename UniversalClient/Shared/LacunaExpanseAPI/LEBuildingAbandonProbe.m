//
//  LEBuildingAbandonProbe.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingAbandonProbe.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingAbandonProbe


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize starId;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl starId:(NSString *)inStarId {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.starId = inStarId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, self.starId);
}


- (void)processSuccess {
	NSLog(@"abandon_probe response: %@", self.response);
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"abandon_probe";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.starId = nil;
	[super dealloc];
}


@end
