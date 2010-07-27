//
//  LEEmpireFound.m
//  DKTest
//
//  Created by Kevin Runde on 3/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEEmpireFound.h"
#import "LEMacros.h"


@implementation LEEmpireFound


@synthesize empireId;
@synthesize sessionId;
@synthesize status;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget empireId:(NSString *)inEmpireId {
	self.empireId = inEmpireId;
	
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	return _array(self.empireId, API_KEY);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.sessionId = [result objectForKey:@"session_id"];
	self.status = [result objectForKey:@"status"];
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"found";
}


- (void)dealloc {
	self.empireId = nil;
	self.sessionId = nil;
	self.status = nil;
	[super dealloc];
}


@end
