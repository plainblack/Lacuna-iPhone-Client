//
//  LEGetSystem.m
//  DKTest
//
//  Created by Kevin Runde on 2/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LEGetSystem.h"
#import "Session.h"
#import "LEMacros.h"


@implementation LEGetSystem


@synthesize systemId;
@synthesize star;
@synthesize bodies;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget systemId:(NSString *)inSystemId {
	self.systemId = inSystemId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}

- (id)params {
	return _array([Session sharedInstance].sessionId, self.systemId);
}


- (void)processSuccess {
	NSLog(@"Loading System Data for '%@': %@", self.systemId, self.response);
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.star = [result objectForKey:@"star"];
	
	NSDictionary *bodyDict = [result objectForKey:@"bodies"];
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:8]; //KEVIN replace 8 with MAX_ORBITS;
	for(int i=0; i<8; i++) { //KEVIN replace 8 with MAX_ORBITS;
		[tmp addObject:[NSNull null]];
	}
	
	for(NSString *bodyId in bodyDict) {
		NSMutableDictionary *body = [bodyDict objectForKey:bodyId];
		[body setObject:bodyId forKey:@"id"];
		int orbit = _intv([body objectForKey:@"orbit"]);
		[tmp replaceObjectAtIndex:orbit	withObject:body];
	}
	self.bodies = tmp;
}


- (NSString *)serviceUrl {
	return @"map";
}


- (NSString *)methodName {
	return @"get_star_system";
}


- (void)dealloc {
	self.systemId = nil;
	self.star = nil;
	self.bodies = nil;
	[super dealloc];
}


@end
