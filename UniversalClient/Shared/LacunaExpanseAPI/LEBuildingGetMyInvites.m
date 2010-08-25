//
//  LEBuildingGetMyInvites.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingGetMyInvites.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingGetMyInvites


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize invites;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId);
}


- (void)processSuccess {
	self.invites = [self.response objectForKey:@"invites"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"get_my_invites";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.invites = nil;
	[super dealloc];
}


@end
