//
//  LEInboxSend.m
//  DKTest
//
//  Created by Kevin Runde on 3/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LEInboxSend.h"
#import "Session.h"
#import "LEMacros.h"


@implementation LEInboxSend


@synthesize recipients;
@synthesize subject;
@synthesize body;
@synthesize options;
@synthesize success;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget recipients:(NSString *)inRecipients subject:(NSString *)inSubject body:(NSString *)inBody options:(NSDictionary *)inOptions {
	self.recipients = inRecipients;
	self.subject = inSubject;
	self.body = inBody;
	self.options = inOptions;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return array_([Session sharedInstance].sessionId, self.recipients, self.subject, self.body, self.options); //KEVIN IS THIS REALLY AN ARRAY OF ARRAY THINGY?
}


- (void)processSuccess {
	NSLog(@"Send Message: %@, %@, %@, %@", self.recipients, self.subject, self.body, self.options);
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.success = [result objectForKey:@"success"];
}


- (NSString *)serviceUrl {
	return @"inbox";
}


- (NSString *)methodName {
	return @"send_message";
}


- (void)dealloc {
	self.recipients = nil;
	self.subject = nil;
	self.body = nil;
	self.options = nil;
	[super dealloc];
}


@end
