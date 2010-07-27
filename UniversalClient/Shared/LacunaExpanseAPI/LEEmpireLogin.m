//
//  LEEmpireLogin.m
//  DKTest
//
//  Created by Kevin Runde on 3/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEEmpireLogin.h"
#import "LEMacros.h"


@implementation LEEmpireLogin


@synthesize username;
@synthesize password;
@synthesize sessionId;
@synthesize empireData;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget username:(NSString *)inUsername password:(NSString *)inPassword {
	self.username = inUsername;
	self.password = inPassword;
	
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	return _array(self.username, self.password, API_KEY);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	NSDictionary *status = [result objectForKey:@"status"];
	self.sessionId = [result objectForKey:@"session_id"];
	self.empireData = [status objectForKey:@"empire"];
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"login";
}


- (void)dealloc {
	self.username = nil;
	self.password = nil;
	self.sessionId = nil;
	self.empireData = nil;
	
	[super dealloc];
}


@end
