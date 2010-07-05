//
//  LEBodyStatus.m
//  UniversalClient
//
//  Created by Kevin Runde on 5/23/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBodyStatus.h"
#import "Session.h"
#import "LEMacros.h"


@implementation LEBodyStatus


@synthesize bodyId;
@synthesize body;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget bodyId:(NSString *)inBodyId {
	self.bodyId = inBodyId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}

- (id)params {
	return _array([Session sharedInstance].sessionId, self.bodyId);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	
	self.body = [result objectForKey:@"body"];
}


- (NSString *)serviceUrl {
	return @"body";
}


- (NSString *)methodName {
	return @"get_status";
}


- (void)dealloc {
	self.bodyId = nil;
	self.body = nil;
	[super dealloc];
}


@end
