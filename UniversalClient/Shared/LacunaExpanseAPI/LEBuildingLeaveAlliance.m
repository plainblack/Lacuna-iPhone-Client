//
//  LEBuildingLeaveAlliance.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingLeaveAlliance.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingLeaveAlliance


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize message;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl message:(NSString *)inMessage {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.message = inMessage;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId);
	if (self.message) {
		[params addObject:self.message];
	}
	return params;
}


- (void)processSuccess {
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"leave_alliance";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.message = nil;
	[super dealloc];
}


@end
