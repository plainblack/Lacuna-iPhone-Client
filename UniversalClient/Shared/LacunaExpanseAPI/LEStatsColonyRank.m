//
//  LEStatsColonyRank.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEStatsColonyRank.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEStatsColonyRank


@synthesize sortBy;
@synthesize colonies;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget sortBy:(NSString *)inSortBy {
	if (inSortBy) {
		self.sortBy = inSortBy;
	} else {
		self.sortBy = @"population_rank";
	}
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return _array(session.sessionId, self.sortBy);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.colonies = [result objectForKey:@"colonies"];
}


- (NSString *)serviceUrl {
	return @"stats";
}


- (NSString *)methodName {
	return @"colony_rank";
}


- (void)dealloc {
	self.sortBy = nil;
	self.colonies = nil;
	[super dealloc];
}


@end
