//
//  LECaptchaSolve.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/1/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LECaptchaSolve.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LECaptchaSolve


@synthesize captchaGuid;
@synthesize captchaSolution;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget captchaGuid:(NSString *)inCaptchaGuid captchaSolution:(NSString *)inCaptchaSolution {
	self.captchaGuid = inCaptchaGuid;
	self.captchaSolution = inCaptchaSolution;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.captchaGuid, self.captchaSolution);
}


- (void)processSuccess {
}


- (NSString *)serviceUrl {
	return @"/captcha";
}


- (NSString *)methodName {
	return @"solve";
}


- (void)dealloc {
	self.captchaGuid = nil;
	self.captchaSolution = nil;
	[super dealloc];
}


@end
