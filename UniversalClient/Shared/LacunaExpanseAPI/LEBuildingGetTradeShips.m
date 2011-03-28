//
//  LEBuildingGetTradeShips.m
//  UniversalClient
//
//  Created by Kevin Runde on 10/21/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingGetTradeShips.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingGetTradeShips


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize targetBodyId;
@synthesize ships;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl targetBodyId:(NSString *)inTargetBodyId {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.targetBodyId = inTargetBodyId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId);
	
	if (self.targetBodyId) {
		[params addObject:self.targetBodyId];
	}
	return params;
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.ships = [result objectForKey:@"ships"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"get_trade_ships";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.targetBodyId = nil;
	self.ships = nil;
	[super dealloc];
}


@end
