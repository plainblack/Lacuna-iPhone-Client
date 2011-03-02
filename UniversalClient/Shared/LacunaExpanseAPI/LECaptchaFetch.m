//
//  LECaptchaFetch.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/1/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LECaptchaFetch.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LECaptchaFetch


@synthesize captchaGuid;
@synthesize captchaUrl;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget {
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId);
}


- (void)processSuccess {
	NSMutableDictionary *result = [self.response objectForKey:@"result"];
	self.captchaGuid = [result objectForKey:@"guid"];
	self.captchaUrl = [result objectForKey:@"url"];
}


- (NSString *)serviceUrl {
	return @"/captcha";
}


- (NSString *)methodName {
	return @"fetch";
}


- (void)dealloc {
	self.captchaGuid = nil;
	self.captchaUrl = nil;
	[super dealloc];
}


@end
