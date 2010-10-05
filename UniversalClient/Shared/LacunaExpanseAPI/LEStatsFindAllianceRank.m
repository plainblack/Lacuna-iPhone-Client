//
//  LEStatsFindAllianceRank.m
//  UniversalClient
//
//  Created by Kevin Runde on 10/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEStatsFindAllianceRank.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEStatsFindAllianceRank


@synthesize sortBy;
@synthesize allianceName;
@synthesize alliances;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget sortBy:(NSString *)inSortBy allianceName:(NSString *)inAllianceName {
	self.sortBy = inSortBy;
	self.allianceName = inAllianceName;
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return _array(session.sessionId, self.sortBy, self.allianceName);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.alliances = [result objectForKey:@"alliances"];
}


- (NSString *)serviceUrl {
	return @"stats";
}


- (NSString *)methodName {
	return @"find_alliance_rank";
}


- (void)dealloc {
	self.sortBy = nil;
	self.allianceName = nil;
	self.alliances = nil;
	[super dealloc];
}


@end
