//
//  LEBuildingTrainSpy.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingTrainSpy.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingTrainSpy

@synthesize buildingId;
@synthesize buildingUrl;
@synthesize quantity;
@synthesize trained;
@synthesize notTrained;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl quantity:(NSDecimalNumber *)inQuantity {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.quantity = inQuantity;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, self.quantity);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.trained = [result objectForKey:@"trained"];
	self.notTrained = [result objectForKey:@"not_trained"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"train_spy";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.quantity = nil;
	self.trained = nil;
	self.notTrained = nil;
	[super dealloc];
}


@end
