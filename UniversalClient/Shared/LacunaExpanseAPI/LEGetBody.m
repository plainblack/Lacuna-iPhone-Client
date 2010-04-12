//
//  LEGetBody.m
//  DKTest
//
//  Created by Kevin Runde on 2/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LEGetBody.h"
#import "Session.h"
#import "LEMacros.h"


@implementation LEGetBody


@synthesize bodyId;
@synthesize body;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget bodyId:(NSString *)inBodyId {
	self.bodyId = inBodyId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}

- (id)params {
	NSLog(@"GetBody: %@, %@", [Session sharedInstance].sessionId, self.bodyId);
	return array_([Session sharedInstance].sessionId, self.bodyId);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	
	NSDictionary *bodyDict = [result objectForKey:@"bodies"];
	self.body = [bodyDict objectForKey:self.bodyId];
}


- (NSString *)serviceUrl {
	return @"map";
}


- (NSString *)methodName {
	return @"get_star_system_by_body";
}


- (void)dealloc {
	self.bodyId = nil;
	self.body = nil;
	[super dealloc];
}


@end
