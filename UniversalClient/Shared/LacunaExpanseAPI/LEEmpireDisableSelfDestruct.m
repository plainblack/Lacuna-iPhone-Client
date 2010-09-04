//
//  LEEmpireDisableSelfDestruct.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEEmpireDisableSelfDestruct.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEEmpireDisableSelfDestruct


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget {
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return _array(session.sessionId);
}


- (void)processSuccess {
	NSLog(@"Disable Self Distruct Response: %@", self.response);
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"disable_self_destruct";
}


- (void)dealloc {
	[super dealloc];
}


@end
