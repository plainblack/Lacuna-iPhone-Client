//
//  LEBuildingAddToMarket.m
//  UniversalClient
//
//  Created by Kevin Runde on 12/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingAddToMarket.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingAddToMarket


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize askEssentia;
@synthesize offer;
@synthesize tradeShipId;
@synthesize tradeId;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl askEssentia:(NSDecimalNumber *)inAskEssentia offer:(NSMutableArray *)inOffer tradeShipId:(NSString *)inTradeShipId {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.askEssentia = inAskEssentia;
	self.offer = inOffer;
	self.tradeShipId = inTradeShipId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId, self.offer, self.askEssentia);
	
	if (self.tradeShipId) {
		[params addObject:_dict(self.tradeShipId, @"ship_id", [NSNumber numberWithInt:1], @"stay")];
	}
	return params;
}


- (void)processSuccess {
	self.tradeId = [self.response objectForKey:@"trade_id"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"add_to_market";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.askEssentia = nil;
	self.offer = nil;
	self.tradeShipId = nil;
	self.tradeId = nil;
	[super dealloc];
}



@end
