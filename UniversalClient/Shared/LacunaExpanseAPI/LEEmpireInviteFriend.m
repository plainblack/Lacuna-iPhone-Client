//
//  LEEmpireInviteFriend.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEEmpireInviteFriend.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEEmpireInviteFriend


@synthesize email;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget email:(NSString *)inEmail {
	self.email = inEmail;
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return _array(session.sessionId, self.email);
}


- (void)processSuccess {
	NSLog(@"Invite Friend: %@", self.response);
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"invite_friend";
}


- (void)dealloc {
	self.email = nil;
	[super dealloc];
}


@end
