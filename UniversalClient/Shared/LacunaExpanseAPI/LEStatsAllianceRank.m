//
//  LEStatsAllianceRank.m
//  UniversalClient
//
//  Created by Kevin Runde on 10/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEStatsAllianceRank.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEStatsAllianceRank


@synthesize sortBy;
@synthesize pageNumber;
@synthesize alliances;
@synthesize numAlliances;


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
	self.alliances = [result objectForKey:@"alliances"];
	self.numAlliances = [Util asNumber:[result objectForKey:@"total_alliances"]];
}


- (NSString *)serviceUrl {
	return @"stats";
}


- (NSString *)methodName {
	return @"alliance_rank";
}


- (void)dealloc {
	self.sortBy = nil;
	self.alliances = nil;
	self.numAlliances = nil;
	[super dealloc];
}



@end
