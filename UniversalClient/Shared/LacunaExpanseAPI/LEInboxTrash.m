//
//  LEInboxTrash.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/30/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEInboxTrash.h"
#import "Session.h"
#import "LEMacros.h"


@implementation LEInboxTrash


@synthesize messageIds;
@synthesize success;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget messageIds:(NSArray *)inMessageIds {
	self.messageIds = inMessageIds;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.messageIds);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.success = [result objectForKey:@"success"];
}


- (NSString *)serviceUrl {
	return @"inbox";
}


- (NSString *)methodName {
	return @"trash_messages";
}


- (void)dealloc {
	self.messageIds = nil;
	self.success = nil;
	[super dealloc];
}


@end
