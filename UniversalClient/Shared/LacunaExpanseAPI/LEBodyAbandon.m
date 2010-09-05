//
//  LEBodyAbandon.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBodyAbandon.h"
#import "Session.h"
#import "LEMacros.h"


@implementation LEBodyAbandon


@synthesize bodyId;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget forBody:(NSString *)inBodyId {
	self.bodyId = inBodyId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}

- (id)params {
	return _array([Session sharedInstance].sessionId, self.bodyId);
}


- (void)processSuccess {
	NSLog(@"Adandon Response: %@", self.response);
}


- (NSString *)serviceUrl {
	return @"body";
}


- (NSString *)methodName {
	return @"abandon";
}


- (void)dealloc {
	self.bodyId = nil;
	[super dealloc];
}


@end
