//
//  LEEmpireBoostSpyTraining.m
//  UniversalClient
//
//  Created by Bernard Kluskens on 02/23/16.
//  Copyright 2016 n/a. All rights reserved.
//

#import "LEEmpireBoostSpyTraining.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEEmpireBoostSpyTraining


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
	self.boostEndDate = [Util date:[result objectForKey:@"spy_training_boost"] ];
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"boost_spy_training";
}


- (void)dealloc {
	self.boostEndDate = nil;
	[super dealloc];
}


@end