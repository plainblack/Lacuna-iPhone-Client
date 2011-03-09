//
//  LEBuildingSendFleet.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/8/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuildingSendFleet.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEBuildingSendFleet


@synthesize shipIds;
@synthesize targetBodyName;
@synthesize targetBodyId;
@synthesize targetStarName;
@synthesize targetStarId;
@synthesize targetX;
@synthesize targetY;
@synthesize fleet;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget shipIds:(NSMutableArray *)inShipIds targetBodyName:(NSString *)inTargetBodyName targetBodyId:(NSString *)inTargetBodyId targetStarName:(NSString *)inTargetStarName targetStarId:(NSString *)inTargetStarId targetX:(NSDecimalNumber *)inTargetX targetY:(NSDecimalNumber *)inTargetY {
	self.shipIds = inShipIds;
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
	NSMutableArray *params = nil;
	
	if (self.targetBodyName) {
		params = _array(session.sessionId, self.shipIds, _dict(self.targetBodyName, @"body_name"));
	} else if (self.targetBodyId) {
		params = _array(session.sessionId, self.shipIds, _dict(self.targetBodyId, @"body_id"));
	} else if (self.targetStarName) {
		params = _array(session.sessionId, self.shipIds, _dict(self.targetStarName, @"star_name"));
	} else if (self.targetStarId) {
		params = _array(session.sessionId, self.shipIds, _dict(self.targetStarId, @"star_id"));
	} else if (self.targetX && self.targetY) {
		params = _array(session.sessionId, self.shipIds, _dict(self.targetX, @"x", self.targetY, @"y"));
	}
	
	return params;
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.fleet = [result objectForKey:@"fleet"];
}


- (NSString *)serviceUrl {
	return @"spaceport";
}


- (NSString *)methodName {
	return @"send_fleet";
}


- (void)dealloc {
	self.shipIds = nil;
	self.targetBodyName = nil;
	self.targetBodyId = nil;
	self.targetStarName = nil;
	self.targetStarId = nil;
	self.targetX = nil;
	self.targetY = nil;
	self.fleet = nil;
	[super dealloc];
}


@end
