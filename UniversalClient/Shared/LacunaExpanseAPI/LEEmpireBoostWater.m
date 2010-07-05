//
//  LEEmpireBoostWater.m
//  UniversalClient
//
//  Created by Kevin Runde on 5/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEEmpireBoostWater.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEEmpireBoostWater


@synthesize boostEndDate;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget {
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return _array(session.sessionId);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.boostEndDate = [Util date:[result objectForKey:@"water_boost"] ];
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"boost_water";
}


- (void)dealloc {
	self.boostEndDate = nil;
	[super dealloc];
}


@end
