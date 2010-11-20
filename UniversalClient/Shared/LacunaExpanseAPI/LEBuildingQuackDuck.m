//
//  LEBuildingQuackDuck.m
//  UniversalClient
//
//  Created by Kevin Runde on 11/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingQuackDuck.h"
#import "Session.h"
#import "LEMacros.h"


@implementation LEBuildingQuackDuck


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize message;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId);
}


- (void)processSuccess {
	self.message = [self.response objectForKey:@"result"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"duck_quack";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.message = nil;
	[super dealloc];
}


@end
