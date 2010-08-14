//
//  LEInboxView.m
//  DKTest
//
//  Created by Kevin Runde on 3/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LEInboxView.h"
#import "Session.h"
#import "LEMacros.h"


@implementation LEInboxView


@synthesize page;
@synthesize messages;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget page:(NSDecimalNumber *)inPage {
	self.page = inPage;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSArray *params = _array([Session sharedInstance].sessionId, _dict(self.page, @"page_number"));
	return params;
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.messages = [result objectForKey:@"messages"];
}


- (NSString *)serviceUrl {
	return @"inbox";
}


- (NSString *)methodName {
	return @"view_inbox";
}


- (void)dealloc {
	self.page = nil;
	self.messages = nil;
	[super dealloc];
}


@end
