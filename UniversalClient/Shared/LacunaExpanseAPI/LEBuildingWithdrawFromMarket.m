//
//  LEBuildingWithdrawFromMarket.m
//  UniversalClient
//
//  Created by Kevin Runde on 12/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingWithdrawFromMarket.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingWithdrawFromMarket


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize tradeId;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl tradeId:(NSString *)inTradeId {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.tradeId = inTradeId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSArray *params = _array([Session sharedInstance].sessionId, self.buildingId, self.tradeId);
	return params;
}


- (void)processSuccess {
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"withdraw_from_market";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.tradeId = nil;
	[super dealloc];
}



@end
