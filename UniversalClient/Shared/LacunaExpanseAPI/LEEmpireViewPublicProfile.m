//
//  LEEmpireViewPublicProfile.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEEmpireViewPublicProfile.h"
#import "LEMacros.h"


@implementation LEEmpireViewPublicProfile


@synthesize sessionId;
@synthesize empireId;
@synthesize profile;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget sessionId:(NSString *)inSessionId empireId:(NSString *)inEmpireId {
	self.sessionId = inSessionId;
	self.empireId = inEmpireId;
	
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	return _array(self.sessionId, self.empireId);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.profile = [result objectForKey:@"profile"];
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"view_public_profile";
}


- (void)dealloc {
	self.sessionId = nil;
	self.empireId = nil;
	self.profile = nil;
	[super dealloc];
}


@end
