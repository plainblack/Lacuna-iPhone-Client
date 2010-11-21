//
//  LEBuildingTransmitCompleteBuildQueue.m
//  UniversalClient
//
//  Created by Kevin Runde on 11/21/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingCompleteBuildQueue.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingCompleteBuildQueue


@synthesize buildingId;
@synthesize buildingUrl;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId);
}


- (void)processSuccess {
	//NSDictionary *result = [self.response objectForKey:@"result"];
	NSLog(@"Complete Build Queue response: %@", self.response);
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"complete_build_queue";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	[super dealloc];
}


@end
