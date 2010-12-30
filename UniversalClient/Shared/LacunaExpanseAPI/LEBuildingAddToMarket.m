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
@synthesize offerType;
@synthesize offerQuantity;
@synthesize offerGlyphId;
@synthesize offerPlanId;
@synthesize offerPrisonerId;
@synthesize offerShipId;
@synthesize tradeShipId;
@synthesize tradeId;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl askEssentia:(NSDecimalNumber *)inAskEssentia offerType:(NSString *)inOfferType offerQuantity:(NSDecimalNumber *)inOfferQuantity offerGlyphId:(NSString *)inOfferGlyphId offerPlanId:(NSString *)inOfferPlanId offerPrisonerId:(NSString *)inOfferPrisonerId offerShipId:(NSString *)inOfferShipId tradeShipId:(NSString *)inTradeShipId {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.askEssentia = inAskEssentia;
	self.offerType = inOfferType;
	self.offerQuantity = inOfferQuantity;
	self.offerGlyphId = inOfferGlyphId;
	self.offerPlanId = inOfferPlanId;
	self.offerPrisonerId = inOfferPrisonerId;
	self.offerShipId = inOfferShipId;
	self.tradeShipId = inTradeShipId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableDictionary *offer = _dict(self.offerType, @"type");
	
	if (self.offerQuantity) {
		[offer setObject:self.offerQuantity forKey:@"quantity"];
	} else {
		[offer setObject:[NSDecimalNumber one] forKey:@"quantity"];
	}
	if (self.offerGlyphId) {
		[offer setObject:self.offerGlyphId forKey:@"glyph_id"];
	}
	if (self.offerPlanId) {
		[offer setObject:self.offerPlanId forKey:@"plan_id"];
	}
	if (self.offerPrisonerId) {
		[offer setObject:self.offerPrisonerId forKey:@"prisoner_id"];
	}
	if (self.offerShipId) {
		[offer setObject:self.offerShipId forKey:@"ship_id"];
	}
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId, _array(offer), self.askEssentia);
	
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
	self.offerType = nil;
	self.offerQuantity = nil;
	self.offerGlyphId = nil;
	self.offerPlanId = nil;
	self.offerPrisonerId = nil;
	self.tradeShipId = nil;
	self.tradeId = nil;
	[super dealloc];
}



@end
