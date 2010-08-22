//
//  LEBuildingTradeOneForOne.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/21/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingTradeOneForOne.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingTradeOneForOne


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize haveResourceType;
@synthesize wantResourceType;
@synthesize quantity;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl haveResourceType:(NSString *)inHaveResourceType wantResourceType:(NSString *)inWantResourceType quantity:(NSDecimalNumber *)inQuantity {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.haveResourceType = inHaveResourceType;
	self.wantResourceType = inWantResourceType;
	self.quantity = inQuantity;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, self.haveResourceType, self.wantResourceType, self.quantity);
}


- (void)processSuccess {
	//NSDictionary *result = [self.response objectForKey:@"result"];
	NSLog(@"Push Items response: %@", self.response);
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"trade_one_for_one";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.haveResourceType = nil;
	self.wantResourceType = nil;
	self.quantity = nil;
	[super dealloc];
}


@end
