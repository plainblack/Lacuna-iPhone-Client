//
//  LEGetBuilding.m
//  DKTest
//
//  Created by Kevin Runde on 3/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LEBuildingView.h"
#import "Session.h"
#import "LEMacros.h"


@implementation LEBuildingView


@synthesize buildingId;
@synthesize result;
@synthesize url;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId url:(NSString *)inUrl {
	self.buildingId = inBuildingId;
	self.url = inUrl;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return array_([Session sharedInstance].sessionId, self.buildingId);
}


- (void)processSuccess {
	self.result = [self.response objectForKey:@"result"];
}


- (NSString *)serviceUrl {
	return self.url;
}


- (NSString *)methodName {
	return @"view";
}


- (void)dealloc {
	self.buildingId = nil;
	self.result = nil;
	self.url = nil;
	[super dealloc];
}


@end
