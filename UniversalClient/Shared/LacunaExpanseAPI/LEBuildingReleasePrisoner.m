//
//  LEBuildingReleasePrisoner.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/6/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingReleasePrisoner.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingReleasePrisoner


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize prisonerId;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl prisonerId:(NSString *)inPrisonerId {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.prisonerId = inPrisonerId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, self.prisonerId);
}


- (void)processSuccess {
	//Does nothing
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"release_prisoner";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.prisonerId = nil;
	[super dealloc];
}


@end
