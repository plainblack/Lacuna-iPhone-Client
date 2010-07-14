//
//  LEBuildingViewPrisoners.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/14/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingViewPrisoners.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingViewPrisoners


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize pageNumber;
@synthesize prisoners;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl pageNumber:(NSInteger)inPageNumber {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.pageNumber = inPageNumber;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, pageNumber);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.prisoners = [result objectForKey:@"prisoners"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"view_prisoners";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.prisoners = nil;
	[super dealloc];
}


@end
