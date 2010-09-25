//
//  LEStatsSpyRank.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEStatsSpyRank.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEStatsSpyRank


@synthesize sortBy;
@synthesize spies;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget sortBy:(NSString *)inSortBy {
	if (inSortBy) {
		self.sortBy = inSortBy;
	} else {
		self.sortBy = @"level_rank";
	}
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return _array(session.sessionId, self.sortBy);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.spies = [result objectForKey:@"spies"];
}


- (NSString *)serviceUrl {
	return @"stats";
}


- (NSString *)methodName {
	return @"spy_rank";
}


- (void)dealloc {
	self.sortBy = nil;
	self.spies = nil;
	[super dealloc];
}


@end
