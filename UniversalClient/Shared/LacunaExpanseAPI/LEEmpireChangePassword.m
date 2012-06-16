//
//  LEEmpireChangePassword.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEEmpireChangePassword.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEEmpireChangePassword


@synthesize password = _password;
@synthesize passwordConfirm = _passwordConfirm;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget newPassword:(NSString *)password newPasswordConfirm:(NSString *)passwordConfirm {
	self.password = password;
	self.passwordConfirm = passwordConfirm;
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return _array(session.sessionId, self.password, self.passwordConfirm);
}


- (void)processSuccess {
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"change_password";
}


- (void)dealloc {
	self.password = nil;
	self.passwordConfirm = nil;
	[super dealloc];
}


@end
