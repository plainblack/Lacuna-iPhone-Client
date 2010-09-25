//
//  LEStatsEmpireRank.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEStatsEmpireRank.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEStatsEmpireRank


@synthesize sortBy;
@synthesize pageNumber;
@synthesize empires;
@synthesize numEmpires;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget sortBy:(NSString *)inSortBy pageNumber:(NSInteger)inPageNumber {
	if (inSortBy) {
		self.sortBy = inSortBy;
	} else {
		self.sortBy = @"level_rank";
	}
	self.pageNumber = inPageNumber;
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return _array(session.sessionId, self.sortBy, [NSDecimalNumber numberWithInt:self.pageNumber]);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.empires = [result objectForKey:@"empires"];
	self.numEmpires = [Util asNumber:[result objectForKey:@"total_empires"]];
}


- (NSString *)serviceUrl {
	return @"stats";
}


- (NSString *)methodName {
	return @"empire_rank";
}


- (void)dealloc {
	self.sortBy = nil;
	self.empires = nil;
	self.numEmpires = nil;
	[super dealloc];
}



@end
