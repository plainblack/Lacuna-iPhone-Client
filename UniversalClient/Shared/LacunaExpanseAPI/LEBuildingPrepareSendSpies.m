//
//  LEBuildingPrepareSendSpies.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingPrepareSendSpies.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEBuildingPrepareSendSpies


@synthesize onBodyId;
@synthesize toBodyId;
@synthesize ships;
@synthesize spies;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget onBodyId:(NSString *)inOnBodyId toBodyId:(NSString *)inToBodyId {
	self.onBodyId	= inOnBodyId;
	self.toBodyId = inToBodyId;
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return _array(session.sessionId, self.onBodyId, self.toBodyId);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.ships = [result objectForKey:@"ships"];
	self.spies = [result objectForKey:@"spies"];
}


- (NSString *)serviceUrl {
	return @"spaceport";
}


- (NSString *)methodName {
	return @"prepare_fetch_spies";
}


- (void)dealloc {
	self.toBodyId = nil;
	self.onBodyId = nil;
	self.ships = nil;
	self.spies = nil;
	[super dealloc];
}


@end
