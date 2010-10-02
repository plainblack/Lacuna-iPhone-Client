//
//  LEMapGetStar.m
//  UniversalClient
//
//  Created by Kevin Runde on 10/1/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEMapGetStar.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEMapGetStar


@synthesize starId;
@synthesize star;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget starId:(NSString *)inStarId {
	self.starId = inStarId;
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return _array(session.sessionId, self.starId);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.star = [result objectForKey:@"star"];
}


- (NSString *)serviceUrl {
	return @"map";
}


- (NSString *)methodName {
	return @"get_star";
}


- (void)dealloc {
	self.starId = nil;
	self.star = nil;
	[super dealloc];
}


@end
