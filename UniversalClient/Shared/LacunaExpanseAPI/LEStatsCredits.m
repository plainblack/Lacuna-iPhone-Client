//
//  LEStatsCredits.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEStatsCredits.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEStatsCredits


@synthesize creditGroups;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget {
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	return [NSArray array];
}


- (void)processSuccess {
	NSArray *data = [self.response objectForKey:@"result"];
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[data count]];
	
	for(NSDictionary *creditGroup in data) {
		for (id key in creditGroup) {
			[tmp addObject:_dict(key, @"title", [creditGroup objectForKey:key], @"names")];
		}
	}
	
	self.creditGroups = tmp;
}


- (NSString *)serviceUrl {
	return @"stats";
}


- (NSString *)methodName {
	return @"credits";
}


- (void)dealloc {
	self.creditGroups = nil;
	[super dealloc];
}


@end
