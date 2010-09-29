//
//  LEBuildingSendSpies.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingSendSpies.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEBuildingSendSpies


@synthesize onBodyId;
@synthesize toBodyId;
@synthesize shipId;
@synthesize spyIds;
@synthesize ship;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget onBodyId:(NSString *)inOnBodyId toBodyId:(NSString *)inToBodyId shipId:(NSString *)inShipId spyIds:(NSMutableArray *)inSpyIds {
	self.onBodyId	= inOnBodyId;
	self.toBodyId = inToBodyId;
	self.shipId = inShipId;
	self.spyIds = inSpyIds;
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return _array(session.sessionId, self.onBodyId, self.toBodyId, self.shipId, self.spyIds);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.ship = [result objectForKey:@"ship"];
}


- (NSString *)serviceUrl {
	return @"spaceport";
}


- (NSString *)methodName {
	return @"send_spies";
}


- (void)dealloc {
	self.toBodyId = nil;
	self.onBodyId = nil;
	self.shipId = nil;
	self.spyIds = nil;
	self.ship = nil;
	[super dealloc];
}


@end
