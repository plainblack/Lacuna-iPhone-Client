//
//  LESpeciesViewStats.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LESpeciesViewStats.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LESpeciesViewStats


@synthesize stats;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget {
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return _array(session.sessionId);
}


- (void)processSuccess {
	NSMutableDictionary *results = [self.response objectForKey:@"result"];
	self.stats = [results objectForKey:@"species"];
	NSLog(@"Stats: %@", self.stats);
}


- (NSString *)serviceUrl {
	return @"species";
}


- (NSString *)methodName {
	return @"view_stats";
}


- (void)dealloc {
	self.stats = nil;
	[super dealloc];
}


@end
