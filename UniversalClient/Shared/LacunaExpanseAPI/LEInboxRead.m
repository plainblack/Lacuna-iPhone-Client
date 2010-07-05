//
//  LEInboxRead.m
//  DKTest
//
//  Created by Kevin Runde on 3/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LEInboxRead.h"
#import "Session.h"
#import "LEMacros.h"


@implementation LEInboxRead


@synthesize messageId;
@synthesize message;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget messageId:(NSString *)inMessageId {
	self.messageId = inMessageId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.messageId);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.message = [result objectForKey:@"message"];
}


- (NSString *)serviceUrl {
	return @"inbox";
}


- (NSString *)methodName {
	return @"read_message";
}


- (void)dealloc {
	self.messageId = nil;
	self.message = nil;
	[super dealloc];
}


@end
