//
//  LEMapSearchStars.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEMapSearchStars.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEMapSearchStars


@synthesize name;
@synthesize stars;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget name:(NSString *)inName {
	self.name = inName;
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return _array(session.sessionId, self.name);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.stars = [result objectForKey:@"stars"];
}


- (NSString *)serviceUrl {
	return @"map";
}


- (NSString *)methodName {
	return @"search_stars";
}


- (void)dealloc {
	self.name = nil;
	self.stars = nil;
	[super dealloc];
}


@end
