//
//  LEBuildingWithdrawTrade.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/22/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingWithdrawTrade.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingWithdrawTrade


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
	NSLog(@"Withdraw params: %@", params);
	return params;
}


- (void)processSuccess {
	NSLog(@"Withdraw Response: %@", self.response);
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"withdraw_trade";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.tradeId = nil;
	[super dealloc];
}


@end
