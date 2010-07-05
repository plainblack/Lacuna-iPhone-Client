//
//  LEInboxArchive.m
//  DKTest
//
//  Created by Kevin Runde on 3/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LEInboxArchive.h"
#import "Session.h"
#import "LEMacros.h"


@implementation LEInboxArchive


@synthesize messageIds;
@synthesize success;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget messageIds:(NSArray *)inMessageIds {
	self.messageIds = inMessageIds;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.messageIds); //KEVIN IS THIS REALLY AN ARRAY OF ARRAY THINGY?
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.success = [result objectForKey:@"success"];
}


- (NSString *)serviceUrl {
	return @"inbox";
}


- (NSString *)methodName {
	return @"archive_messages";
}


- (void)dealloc {
	self.messageIds = nil;
	self.success = nil;
	[super dealloc];
}


@end
