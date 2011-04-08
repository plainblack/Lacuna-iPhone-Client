//
//  LEBuildingViewLaws.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/8/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuildingViewLaws.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingViewLaws


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize laws;


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
	NSMutableDictionary *result = [self.response objectForKey:@"result"];
    self.laws = [result objectForKey:@"laws"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"view_laws";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
    self.laws = nil;
	[super dealloc];
}


@end
