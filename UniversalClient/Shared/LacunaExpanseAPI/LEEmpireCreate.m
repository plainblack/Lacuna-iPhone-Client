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
@synthesize empireId;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget name:(NSString *)inName password:(NSString *)inPassword password1:(NSString *)inPassword1 {
	self.name = inName;
	self.password = inPassword;
	self.password1 = inPassword1;

	return [self initWithCallback:inCallback target:inTarget];
}

- (id)params {
	return _dict(self.name, @"name", self.password, @"password", self.password1, @"password1");
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
	self.empireId = nil;
	[super dealloc];
}


@end