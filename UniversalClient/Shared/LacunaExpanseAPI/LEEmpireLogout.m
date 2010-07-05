//
//  LEEmpireLogout.m
//  DKTest
//
//  Created by Kevin Runde on 3/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEEmpireLogout.h"
#import "LEMacros.h"


@implementation LEEmpireLogout


@synthesize sessionId;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget sessionId:(NSString *)inSessionId {
	self.sessionId = inSessionId;
	
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	return _array(self.sessionId);
}


- (void)processSuccess {
	NSNumber *number = [self.response objectForKey:@"result"];
	result = [number boolValue];
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"logout";
}


- (void)dealloc {
	self.sessionId = nil;
	
	[super dealloc];
}


#pragma mark -
#pragma mark Instance Methods


- (BOOL)result {
	return result;
}


@end
