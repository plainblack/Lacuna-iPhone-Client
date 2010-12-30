//
//  LEBuildingAcceptFromMarket.m
//  UniversalClient
//
//  Created by Kevin Runde on 12/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingAcceptFromMarket.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingAcceptFromMarket


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize tradeId;
@synthesize captchaGuid;
@synthesize captchaSolution;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl tradeId:(NSString *)inTradeId captchaGuid:(NSString *)inCaptchaGuid captchaSolution:(NSString *)inCaptchaSolution {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.tradeId = inTradeId;
	self.captchaGuid = inCaptchaGuid;
	self.captchaSolution = inCaptchaSolution;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId, self.tradeId, self.captchaGuid, self.captchaSolution);
	
	return params;
}


- (void)processSuccess {
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"accept_from_market";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.tradeId = nil;
	self.captchaGuid = nil;
	self.captchaSolution = nil;
	[super dealloc];
}


@end
