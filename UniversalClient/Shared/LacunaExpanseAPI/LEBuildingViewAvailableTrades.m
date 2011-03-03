//
//  LEBuildingViewAvailableTrades.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingViewAvailableTrades.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingViewAvailableTrades


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize pageNumber;
@synthesize availableTrades;
@synthesize tradeCount;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl pageNumber:(NSInteger)inPageNumber {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.pageNumber = inPageNumber;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, [NSDecimalNumber numberWithInt:self.pageNumber]);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	
	self.availableTrades = [result objectForKey:@"trades"];
	self.tradeCount = [Util asNumber:[result objectForKey:@"trade_count"]];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"view_available_trades";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.availableTrades = nil;
	self.tradeCount = nil;
	[super dealloc];
}


@end
