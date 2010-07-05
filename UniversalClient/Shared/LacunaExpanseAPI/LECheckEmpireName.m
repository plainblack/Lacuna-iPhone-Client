//
//  LECheckEmpireName.m
//  DKTest
//
//  Created by Kevin Runde on 2/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LECheckEmpireName.h"
#import "LEMacros.h"


@implementation LECheckEmpireName


@synthesize name;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget name:(NSString *)inName {
	self.name = inName;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (BOOL)nameIsAvailable {
	return _intv([self.response objectForKey:@"result"]) == 1;
}


- (id)params {
	return _array(self.name);
}


- (void)processSuccess {
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"is_name_available";
}


- (void)dealloc {
	self.name = nil;
	[super dealloc];
}


@end
