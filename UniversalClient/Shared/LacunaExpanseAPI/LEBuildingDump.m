//
//  LEBuildingDump.m
//  UniversalClient
//
//  Created by Kevin Runde on 11/16/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingDump.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingDump


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize type;
@synthesize amount;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl amount:(NSDecimalNumber *)inAmount {
	return [self initWithCallback:inCallback target:inTarget buildingId:inBuildingId buildingUrl:inBuildingUrl type:nil amount:inAmount];
}


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl type:(NSString *)inType amount:(NSDecimalNumber *)inAmount {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.type = inType;
	self.amount = inAmount;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	if (self.type) {
		return _array([Session sharedInstance].sessionId, self.buildingId, self.type, self.amount);
	} else {
		return _array([Session sharedInstance].sessionId, self.buildingId, self.amount);
	}

}


- (void)processSuccess {
	// Do nothing
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"dump";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.type = nil;
	self.amount = nil;
	[super dealloc];
}


@end
