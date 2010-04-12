//
//  LECheckSpeciesName.m
//  DKTest
//
//  Created by Kevin Runde on 2/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LECheckSpeciesName.h"
#import "LEMacros.h"


@implementation LECheckSpeciesName


@synthesize name;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget name:(NSString *)inName {
	self.name = inName;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (BOOL)nameIsAvailable {
	return intv_([self.response objectForKey:@"result"]) == 1;
}


- (id)params {
	return array_(self.name);
}


- (void)processSuccess {
}


- (NSString *)serviceUrl {
	return @"species";
}


- (NSString *)methodName {
	return @"is_name_available";
}


- (void)dealloc {
	self.name = nil;
	[super dealloc];
}


@end
