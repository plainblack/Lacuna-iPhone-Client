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
@synthesize fleetSpeed;
@synthesize fleet;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget shipIds:(NSMutableArray *)inShipIds targetBodyName:(NSString *)inTargetBodyName targetBodyId:(NSString *)inTargetBodyId targetStarName:(NSString *)inTargetStarName targetStarId:(NSString *)inTargetStarId targetX:(NSDecimalNumber *)inTargetX targetY:(NSDecimalNumber *)inTargetY fleetSpeed:(NSDecimalNumber *)inFleetSpeed {
	self.shipIds = inShipIds;
	self.targetBodyName = inTargetBodyName;
	self.targetBodyId = inTargetBodyId;
	self.targetStarName = inTargetStarName;
	self.targetStarId = inTargetStarId;
	self.targetX = inTargetX;
	self.targetY = inTargetY;
    self.fleetSpeed = inFleetSpeed;
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	NSMutableArray *params = _array(session.sessionId, self.shipIds);
	
	if (self.targetBodyName) {
		[params addObject:_dict(self.targetBodyName, @"body_name")];
	} else if (self.targetBodyId) {
		[params addObject:_dict(self.targetBodyId, @"body_id")];
	} else if (self.targetStarName) {
		[params addObject:_dict(self.targetStarName, @"star_name")];
	} else if (self.targetStarId) {
		[params addObject:_dict(self.targetStarId, @"star_id")];
	} else if (self.targetX && self.targetY) {
		[params addObject:_dict(self.targetX, @"x", self.targetY, @"y")];
    }
    [params addObject:self.fleetSpeed];
	
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
    self.fleetSpeed = nil;
	self.fleet = nil;
	[super dealloc];
}


@end
