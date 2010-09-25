//
//  LEStatsWeeklyMedalWinners.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEStatsWeeklyMedalWinners.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEStatsWeeklyMedalWinners


@synthesize winners;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget {
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return _array(session.sessionId);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.winners = [result objectForKey:@"winners"];
}


- (NSString *)serviceUrl {
	return @"stats";
}


- (NSString *)methodName {
	return @"weekly_medal_winners";
}


- (void)dealloc {
	self.winners = nil;
	[super dealloc];
}


@end
