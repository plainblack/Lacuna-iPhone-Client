//
//  LEEmpireViewProfile.m
//  DKTest
//
//  Created by Kevin Runde on 3/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEEmpireViewProfile.h"
#import "LEMacros.h"


@implementation LEEmpireViewProfile


@synthesize sessionId;
@synthesize description;
@synthesize status;
@synthesize medals;


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
	self.description = [profile objectForKey:@"description"];
	self.status = [profile objectForKey:@"status_message"];
	
	NSMutableDictionary *medalsDictionary = [profile objectForKey:@"medals"];
	NSMutableArray *medalArray = [NSMutableArray arrayWithCapacity:[medalsDictionary count]];
	for (NSString *medalId in medalsDictionary) {
		NSMutableDictionary *medalDictionary = [medalsDictionary objectForKey:medalId];
		[medalDictionary setObject:medalId forKey:@"id"];
		[medalArray addObject:medalDictionary];
	}
	[medalArray sortUsingDescriptors:array_([[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES])];

	self.medals = medalArray;
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"view_profile";
}


- (void)dealloc {
	self.sessionId = nil;
	self.description = nil;
	self.status = nil;
	self.medals = nil;
	[super dealloc];
}


@end
