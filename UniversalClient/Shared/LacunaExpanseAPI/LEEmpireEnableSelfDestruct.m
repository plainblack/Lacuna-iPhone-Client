//
//  LEEmpireEnableSelfDestruct.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEEmpireEnableSelfDestruct.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEEmpireEnableSelfDestruct


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget {
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return _array(session.sessionId);
}


- (void)processSuccess {
	NSLog(@"Enable Self Desctruct Response: %@", self.response);
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"enable_self_destruct";
}


- (void)dealloc {
	[super dealloc];
}


@end
