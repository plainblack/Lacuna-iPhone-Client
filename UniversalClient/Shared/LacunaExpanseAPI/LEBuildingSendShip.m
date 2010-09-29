//
//  LEBuildingSendShip.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingSendShip.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEBuildingSendShip


@synthesize shipId;
@synthesize targetBodyName;
@synthesize targetBodyId;
@synthesize targetStarName;
@synthesize targetStarId;
@synthesize targetX;
@synthesize targetY;
@synthesize ship;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget shipId:(NSString *)inShipId targetBodyName:(NSString *)inTargetBodyName targetBodyId:(NSString *)inTargetBodyId targetStarName:(NSString *)inTargetStarName targetStarId:(NSString *)inTargetStarId targetX:(NSDecimalNumber *)inTargetX targetY:(NSDecimalNumber *)inTargetY {
	self.shipId	= inShipId;
	self.targetBodyName = inTargetBodyName;
	self.targetBodyId = inTargetBodyId;
	self.targetStarName = inTargetStarName;
	self.targetStarId = inTargetStarId;
	self.targetX = inTargetX;
	self.targetY = inTargetY;
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	NSMutableArray *params;
	
	if (self.targetBodyName) {
		params = _array(session.sessionId, self.shipId, _dict(self.targetBodyName, @"body_name"));
	} else if (self.targetBodyId) {
		params = _array(session.sessionId, self.shipId, _dict(self.targetBodyId, @"body_id"));
	} else if (self.targetStarName) {
		params = _array(session.sessionId, self.shipId, _dict(self.targetStarName, @"star_name"));
	} else if (self.targetStarId) {
		params = _array(session.sessionId, self.shipId, _dict(self.targetStarId, @"star_id"));
	} else if (self.targetX && self.targetY) {
		params = _array(session.sessionId, self.shipId, _dict(self.targetX, @"x", self.targetY, @"y"));
	}
	
	return params;
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.ship = [result objectForKey:@"ship"];
}


- (NSString *)serviceUrl {
	return @"spaceport";
}


- (NSString *)methodName {
	return @"send_ship";
}


- (void)dealloc {
	self.shipId = nil;
	self.targetBodyName = nil;
	self.targetBodyId = nil;
	self.targetStarName = nil;
	self.targetStarId = nil;
	self.targetX = nil;
	self.targetY = nil;
	self.ship = nil;
	[super dealloc];
}


@end
