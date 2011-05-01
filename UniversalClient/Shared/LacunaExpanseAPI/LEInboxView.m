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
@synthesize tags;
@synthesize messages;
@synthesize messageCount;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget page:(NSDecimalNumber *)inPage tags:(NSArray *)inTags{
	self.page = inPage;
    self.tags = inTags;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
    NSMutableDictionary *options = _dict(self.page, @"page_number");
    if ([self.tags count] > 0) {
        [options setObject:self.tags forKey:@"tags"];
    }
    
	NSArray *params = _array([Session sharedInstance].sessionId, options);
	return params;
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.messages = [result objectForKey:@"messages"];
	self.messageCount = [result objectForKey:@"message_count"];
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
	self.messageCount = nil;
	[super dealloc];
}


@end
