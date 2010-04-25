//
//  LEBuildingBurnSpy.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingBurnSpy.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingBurnSpy


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize spyId;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl spyId:(NSString *)inSpyId {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.spyId = inSpyId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return array_([Session sharedInstance].sessionId, self.buildingId, self.spyId);
}


- (void)processSuccess {
	//Does nothing
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"burn_spy";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.spyId = nil;
	[super dealloc];
}


@end
