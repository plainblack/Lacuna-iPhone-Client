//
//  LEBuildBuilding.m
//  DKTest
//
//  Created by Kevin Runde on 3/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LEBuildBuilding.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEBuildBuilding


@synthesize bodyId;
@synthesize x;
@synthesize y;
@synthesize url;
@synthesize building;
@synthesize buildingId;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget bodyId:(NSString *)inBodyId x:(NSDecimalNumber *)inX y:(NSDecimalNumber *)inY url:(NSString *)inUrl {
	self.bodyId = inBodyId;
	self.x = inX;
	self.y = inY;
	self.url = inUrl;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.bodyId, self.x, self.y);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.building = [result objectForKey:@"building"];
	self.buildingId = [Util idFromDict:building named:@"id"];
}


- (NSString *)serviceUrl {
	return self.url;
}


- (NSString *)methodName {
	return @"build";
}


- (void)dealloc {
	self.bodyId = nil;
	self.x = nil;
	self.y = nil;
	self.url = nil;
	self.building = nil;
	self.buildingId = nil;
	[super dealloc];
}


@end
