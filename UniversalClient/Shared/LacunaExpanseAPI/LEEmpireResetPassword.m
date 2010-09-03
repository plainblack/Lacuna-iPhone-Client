//
//  LEEmpireResetPassword.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/2/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEEmpireResetPassword.h"
#import "LEMacros.h"


@implementation LEEmpireResetPassword


@synthesize resetKey;
@synthesize password;
@synthesize passwordConfirmation;
@synthesize empireName;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget resetKey:(NSString *)inResetKey password:(NSString *)inPassword passwordConfirmation:(NSString *)inPasswordConfirmation {
	self.resetKey = inResetKey;
	self.password = inPassword;
	self.passwordConfirmation = inPasswordConfirmation;
	
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	NSMutableArray *params = _array(self.resetKey, self.password, self.passwordConfirmation, API_KEY);
	
	NSLog(@"Reset Password params: %@", params);
	return params;
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	NSDictionary *status = [result objectForKey:@"status"];
	self.empireName = [status objectForKey:@"empire"];
	NSLog(@"Empire Name: %@", self.empireName);
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"reset_password";
}


- (void)dealloc {
	self.resetKey = nil;
	self.password = nil;
	self.passwordConfirmation = nil;
	self.empireName = nil;
	[super dealloc];
}


@end
