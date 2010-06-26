//
//  LEEmpireViewProfile.m
//  DKTest
//
//  Created by Kevin Runde on 3/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEEmpireViewProfile.h"
#import "LEMacros.h"
#import "EmpireProfile.h"


@implementation LEEmpireViewProfile


@synthesize sessionId;
@synthesize empire;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget sessionId:(NSString *)inSessionId {
	self.sessionId = inSessionId;
	
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	return array_(self.sessionId);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	NSDictionary *profile = [result objectForKey:@"profile"];
	EmpireProfile *newEmpire = [[[EmpireProfile alloc] init] autorelease];
	newEmpire.description = [profile objectForKey:@"description"];
	newEmpire.status = [profile objectForKey:@"status_message"];
	
	NSMutableDictionary *medalsDictionary = [profile objectForKey:@"medals"];
	NSMutableArray *medalArray = [NSMutableArray arrayWithCapacity:[medalsDictionary count]];
	for (NSString *medalId in medalsDictionary) {
		NSMutableDictionary *medalDictionary = [medalsDictionary objectForKey:medalId];
		[medalDictionary setObject:medalId forKey:@"id"];
		[medalArray addObject:medalDictionary];
	}
	[medalArray sortUsingDescriptors:array_([[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES])];

	newEmpire.medals = medalArray;
	self.empire = newEmpire;
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"view_profile";
}


- (void)dealloc {
	self.sessionId = nil;
	self.empire = nil;
	[super dealloc];
}


@end
