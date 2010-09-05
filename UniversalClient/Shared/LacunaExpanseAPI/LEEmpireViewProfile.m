//
//  LEEmpireViewProfile.m
//  DKTest
//
//  Created by Kevin Runde on 3/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEEmpireViewProfile.h"
#import "LEMacros.h"
#import "EmpireProfile.h"


@implementation LEEmpireViewProfile


@synthesize sessionId;
@synthesize empire;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget sessionId:(NSString *)inSessionId {
	self.sessionId = inSessionId;
	
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	return _array(self.sessionId);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	NSDictionary *profileData = [result objectForKey:@"profile"];
	EmpireProfile *newEmpire = [[[EmpireProfile alloc] init] autorelease];
	[newEmpire parseData:profileData];
	self.empire = newEmpire;
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"view_profile";
}


- (void)dealloc {
	self.sessionId = nil;
	self.empire = nil;
	[super dealloc];
}


@end
