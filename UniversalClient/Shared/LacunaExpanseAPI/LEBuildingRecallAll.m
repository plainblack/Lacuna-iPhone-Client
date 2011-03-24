//
//  LEBuildingRecallAll.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/24/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuildingRecallAll.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingRecallAll


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize ships;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId);
}


- (void)processSuccess {
	NSMutableDictionary *result = [self.response objectForKey:@"result"];
    self.ships = [result objectForKey:@"ships"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"recall_all";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
    self.ships = nil;
	[super dealloc];
}


@end
