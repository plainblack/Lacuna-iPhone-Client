//
//  LEEmpireFind.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEEmpireFind.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEEmpireFind


@synthesize empireName;
@synthesize empiresFound;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget empireName:(NSString *)inEmpireName {
	self.empireName	= inEmpireName;
	
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return _array(session.sessionId, empireName);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.empiresFound = [result objectForKey:@"empires"];
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"find";
}


- (void)dealloc {
	self.empireName	= nil;
	self.empiresFound = nil;
	[super dealloc];
}


@end
