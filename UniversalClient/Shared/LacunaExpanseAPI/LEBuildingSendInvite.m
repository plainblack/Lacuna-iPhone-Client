//
//  LEBuildingSendInvite.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingSendInvite.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingSendInvite


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize inviteeId;
@synthesize message;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl inviteeId:(NSString *)inInviteeId message:(NSString *)inMessage {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.inviteeId = inInviteeId;
	self.message = inMessage;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId, self.inviteeId);
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
	return @"send_invite";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.inviteeId = nil;
	self.message = nil;
	[super dealloc];
}


@end
