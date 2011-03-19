//
//  LEBuildingMakePlan.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/18/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuildingMakePlan.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingMakePlan


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize type;
@synthesize level;
@synthesize result;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl type:(NSString *)inType level:(NSDecimalNumber *)inLevel {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.type = inType;
	self.level = inLevel;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId, self.type, self.level);
	return params;
}


- (void)processSuccess {
	self.result = [self.response objectForKey:@"result"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"make_plan";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.type = nil;
	self.level = nil;
    self.result = nil;
	[super dealloc];
}


@end
