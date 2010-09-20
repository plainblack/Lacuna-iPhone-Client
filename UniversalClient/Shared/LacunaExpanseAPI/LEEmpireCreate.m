//
//  LEEmpireCreate.m
//  DKTest
//
//  Created by Kevin Runde on 3/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEEmpireCreate.h"
#import "Session.h"
#import "LEMacros.h"


@implementation LEEmpireCreate


@synthesize name;
@synthesize password;
@synthesize password1;
@synthesize captchaGuid;
@synthesize captchaSolution;
@synthesize email;
@synthesize empireId;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget name:(NSString *)inName password:(NSString *)inPassword password1:(NSString *)inPassword1 captchaGuid:(NSString *)inCaptchaGuid captchaSolution:(NSString *)inCaptchaSolution email:(NSString *)inEmail {
	self.name = inName;
	self.password = inPassword;
	self.password1 = inPassword1;
	self.captchaGuid = inCaptchaGuid;
	self.captchaSolution = inCaptchaSolution;
	self.email = inEmail;
	return [super initWithCallback:inCallback target:inTarget];
}

- (id)params {
	NSMutableDictionary *params = _dict(self.name, @"name", self.password, @"password", self.password1, @"password1", self.captchaGuid, @"captcha_guid", self.captchaSolution, @"captcha_solution");
	if (self.email && ([self.email length] > 0)) {
		[params setObject:self.email forKey:@"email"];
	}
	return params;
}


- (void)processSuccess {
	NSString *result = [self.response objectForKey:@"result"];
	self.empireId = result;
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"create";
}


- (void)dealloc {
	self.name = nil;
	self.password = nil;
	self.password1 = nil;
	self.captchaGuid = nil;
	self.captchaSolution = nil;
	self.email = nil;
	self.empireId = nil;
	[super dealloc];
}


@end