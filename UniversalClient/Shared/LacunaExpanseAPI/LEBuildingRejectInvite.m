//
//  LEBuildingRejectInvite.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingRejectInvite.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingRejectInvite


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize inviteId;
@synthesize message;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl inviteId:(NSString *)inInviteId message:(NSString *)inMessage {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.inviteId = inInviteId;
	self.message = inMessage;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId, self.inviteId);
	if (self.message) {
		[params addObject:self.message];
	}
	return params;
}


- (void)processSuccess {
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"reject_invite";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.inviteId = nil;
	self.message = nil;
	[super dealloc];
}


@end
