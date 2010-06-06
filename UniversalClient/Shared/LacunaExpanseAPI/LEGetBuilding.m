//
//  LEGetBuilding.m
//  DKTest
//
//  Created by Kevin Runde on 3/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LEGetBuilding.h"
#import "Session.h"
#import "LEMacros.h"


@implementation LEGetBuilding


@synthesize buildingId;
@synthesize building;
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
	NSDictionary *result = [self.response objectForKey:@"result"];
	
	self.building = [result objectForKey:@"building"];
}


- (NSString *)serviceUrl {
	return self.url;
}


- (NSString *)methodName {
	return @"view";
}


- (void)dealloc {
	self.buildingId = nil;
	self.building = nil;
	self.url = nil;
	[super dealloc];
}


@end
