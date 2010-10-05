//
//  LEAllianceFind.m
//  UniversalClient
//
//  Created by Kevin Runde on 10/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEAllianceFind.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEAllianceFind


@synthesize allianceName;
@synthesize alliances;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget allianceName:(NSString *)inAllianceName {
	self.allianceName = inAllianceName;
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return _array(session.sessionId, self.allianceName);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.alliances = [result objectForKey:@"alliances"];
}


- (NSString *)serviceUrl {
	return @"alliance";
}


- (NSString *)methodName {
	return @"find";
}


- (void)dealloc {
	self.allianceName = nil;
	self.alliances = nil;
	[super dealloc];
}


@end
