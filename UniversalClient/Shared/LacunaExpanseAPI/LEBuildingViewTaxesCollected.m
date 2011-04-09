//
//  LEBuildingViewTaxesCollected.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/9/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuildingViewTaxesCollected.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingViewTaxesCollected


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize results;
@synthesize taxesCollected;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId);
	return params;
}


- (void)processSuccess {
    self.results = [self.response objectForKey:@"result"];
    self.taxesCollected = [self.results objectForKey:@"taxes_collected"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"view_taxes_collected";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
    self.results = nil;
    self.taxesCollected = nil;
	[super dealloc];
}


@end
