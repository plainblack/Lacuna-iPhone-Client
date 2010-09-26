//
//  LEStatsFineEmpireRank.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEStatsFindEmpireRank.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEStatsFindEmpireRank


@synthesize sortBy;
@synthesize empireName;
@synthesize empires;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget sortBy:(NSString *)inSortBy empireName:(NSString *)inEmpireName {
	self.sortBy = inSortBy;
	self.empireName = inEmpireName;
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return _array(session.sessionId, self.sortBy, self.empireName);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.empires = [result objectForKey:@"empires"];
}


- (NSString *)serviceUrl {
	return @"stats";
}


- (NSString *)methodName {
	return @"find_empire_rank";
}


- (void)dealloc {
	self.sortBy = nil;
	self.empireName = nil;
	self.empires = nil;
	[super dealloc];
}


@end
