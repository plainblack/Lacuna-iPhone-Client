//
//  LEBuildingViewMarket.m
//  UniversalClient
//
//  Created by Kevin Runde on 12/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingViewMarket.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingViewMarket


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize pageNumber;
@synthesize filter;
@synthesize availableTrades;
@synthesize tradeCount;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl pageNumber:(NSInteger)inPageNumber filter:(NSString *)inFilter {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.pageNumber = inPageNumber;
	self.filter = inFilter;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId, [NSDecimalNumber numberWithInt:self.pageNumber]);
	
	if (self.filter) {
		[params addObject:self.filter];
	}
	
	return params;
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
	return @"view_market";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.filter = nil;
	self.availableTrades = nil;
	self.tradeCount = nil;
	[super dealloc];
}



@end
