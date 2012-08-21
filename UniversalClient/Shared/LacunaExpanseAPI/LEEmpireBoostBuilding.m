//
//  LEEmpireBoostBuilding.m
//  UniversalClient
//
//  Created by Bernard Kluskens on 8/20/12.
//  Copyright 2012 n/a. All rights reserved.
//

#import "LEEmpireBoostBuilding.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEEmpireBoostBuilding


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
	self.boostEndDate = [Util date:[result objectForKey:@"building_boost"] ];
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"boost_building";
}


- (void)dealloc {
	self.boostEndDate = nil;
	[super dealloc];
}


@end
