//
//  LEBuildingReleaseReserve.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/16/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuildingReleaseReserve.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingReleaseReserve


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize result;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId);
}


- (void)processSuccess {
	self.result = [self.response objectForKey:@"result"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"release_reserve";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
    self.result = nil;
	[super dealloc];
}



@end
