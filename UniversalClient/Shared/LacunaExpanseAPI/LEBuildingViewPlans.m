//
//  LEBuildingViewPlans.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/12/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingViewPlans.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingViewPlans


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize plans;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	NSMutableArray *tmp = [result objectForKey:@"plans"];
	[tmp sortUsingDescriptors:_array([[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease])];
	self.plans = tmp;
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"view_plans";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.plans = nil;
	[super dealloc];
}


@end
