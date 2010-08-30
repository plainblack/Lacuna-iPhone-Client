//
//  LESpeciesSetHuman.m
//  DKTest
//
//  Created by Kevin Runde on 3/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LESpeciesSetHuman.h"
#import "LEMacros.h"


@implementation LESpeciesSetHuman


@synthesize empireId;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget empireId:(NSString *)inEmpireId {
	self.empireId = inEmpireId;
	
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	return _array(self.empireId);
}


- (void)processSuccess {
	NSLog(@"Response: %@", self.response);
	NSDecimalNumber *result = [self.response objectForKey:@"result"];
	if ([result intValue] != 1) {
		wasError = YES;
	}
}


- (NSString *)serviceUrl {
	return @"species";
}


- (NSString *)methodName {
	return @"set_human";
}


- (void)dealloc {
	self.empireId = nil;
	[super dealloc];
}


@end
