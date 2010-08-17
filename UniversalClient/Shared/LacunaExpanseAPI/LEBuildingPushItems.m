//
//  LEBuildingPushItems.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingPushItems.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingPushItems


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize targetId;
@synthesize items;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl targetId:(NSString *)inTargetId items:(NSMutableArray *)inItems {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.targetId = inTargetId;
	self.items = inItems;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, self.targetId, self.items);
}


- (void)processSuccess {
	//NSDictionary *result = [self.response objectForKey:@"result"];
	NSLog(@"Push Items response: %@", self.response);
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"push_items";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.targetId = nil;
	self.items = nil;
	[super dealloc];
}


@end
