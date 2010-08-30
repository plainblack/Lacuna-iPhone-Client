//
//  LEEmpireFetchCaptcha.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEEmpireFetchCaptcha.h"
#import "Session.h"
#import "LEMacros.h"


@implementation LEEmpireFetchCaptcha


@synthesize guid;
@synthesize url;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget {
	return [super initWithCallback:inCallback target:inTarget];
}

- (id)params {
	return [NSDictionary dictionary];
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.guid = [result objectForKey:@"guid"];
	self.url = [result objectForKey:@"url"];
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"fetch_captcha";
}


- (void)dealloc {
	self.guid = nil;
	self.url = nil;
	[super dealloc];
}


@end
