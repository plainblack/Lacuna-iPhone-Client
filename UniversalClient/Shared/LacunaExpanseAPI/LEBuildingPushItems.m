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
@synthesize tradeShipId;
@synthesize stayAtTarget;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl targetId:(NSString *)inTargetId items:(NSMutableArray *)inItems tradeShipId:(NSString *)inTradeShipId stayAtTarget:(BOOL)inStayAtTarget {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.targetId = inTargetId;
	self.items = inItems;
	self.tradeShipId = inTradeShipId;
	self.stayAtTarget = inStayAtTarget;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId, self.targetId, self.items);
	
	if (self.tradeShipId) {
		if (self.stayAtTarget) {
			[params addObject:_dict(self.tradeShipId, @"ship_id", [NSNumber numberWithInt:1], @"stay")];
		} else {
			[params addObject:_dict(self.tradeShipId, @"ship_id")];
		}
	}
	NSLog(@"Item Push Params: %@", params);
	return params;
}


- (void)processSuccess {
	//NSDictionary *result = [self.response objectForKey:@"result"];
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
	self.tradeShipId = nil;
	[super dealloc];
}


@end
