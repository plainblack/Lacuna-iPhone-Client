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


@synthesize stationId;
@synthesize buildingUrl;
@synthesize laws;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget stationId:(NSString *)inStationId buildingUrl:(NSString *)inBuildingUrl {
	self.stationId = inStationId;
	self.buildingUrl = inBuildingUrl;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.stationId);
    NSLog(@"Params: %@", params);
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
	self.stationId = nil;
	self.buildingUrl = nil;
    self.laws = nil;
	[super dealloc];
}


@end
