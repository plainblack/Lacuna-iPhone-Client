//
//  LEAllianceViewProfile.m
//  UniversalClient
//
//  Created by Kevin Runde on 10/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEAllianceViewProfile.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEAllianceViewProfile


@synthesize allianceId;
@synthesize profile;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget allianceId:(NSString *)inAllianceId {
	self.allianceId = inAllianceId;
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return _array(session.sessionId, self.allianceId);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.profile = [result objectForKey:@"profile"];
}


- (NSString *)serviceUrl {
	return @"alliance";
}


- (NSString *)methodName {
	return @"view_profile";
}


- (void)dealloc {
	self.allianceId = nil;
	self.profile = nil;
	[super dealloc];
}


@end
