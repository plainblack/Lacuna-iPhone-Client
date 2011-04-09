//
//  LEBuildingProposeBroadcastOnNetwork19.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/9/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuildingProposeBroadcastOnNetwork19.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingProposeBroadcastOnNetwork19


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize message;
@synthesize results;
@synthesize proposition;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl message:(NSString *)inMessage {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
    self.message = inMessage;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId, self.message);
	return params;
}


- (void)processSuccess {
    self.results = [self.response objectForKey:@"result"];
    self.proposition = [self.results objectForKey:@"proposition"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"propose_broadcast_on_network19";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
    self.message = nil;
    self.results = nil;
    self.proposition = nil;
	[super dealloc];
}


@end
