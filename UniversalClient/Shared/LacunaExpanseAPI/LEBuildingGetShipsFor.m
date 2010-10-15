//
//  LEBuildingGetShipsFor.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingGetShipsFor.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEBuildingGetShipsFor


@synthesize fromBodyId;
@synthesize targetBodyName;
@synthesize targetBodyId;
@synthesize targetStarName;
@synthesize targetStarId;
@synthesize targetX;
@synthesize targetY;
@synthesize incoming;
@synthesize available;
@synthesize unavailabe;
@synthesize miningPlatforms;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget fromBodyId:(NSString *)inFromBodyId targetBodyName:(NSString *)inTargetBodyName targetBodyId:(NSString *)inTargetBodyId targetStarName:(NSString *)inTargetStarName targetStarId:(NSString *)inTargetStarId targetX:(NSDecimalNumber *)inTargetX targetY:(NSDecimalNumber *)inTargetY {
	self.fromBodyId	= inFromBodyId;
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
		params = _array(session.sessionId, self.fromBodyId, _dict(self.targetBodyName, @"body_name"));
	} else if (self.targetBodyId) {
		params = _array(session.sessionId, self.fromBodyId, _dict(self.targetBodyId, @"body_id"));
	} else if (self.targetStarName) {
		params = _array(session.sessionId, self.fromBodyId, _dict(self.targetStarName, @"star_name"));
	} else if (self.targetStarId) {
		params = _array(session.sessionId, self.fromBodyId, _dict(self.targetStarId, @"star_id"));
	} else if (self.targetX && self.targetY) {
		params = _array(session.sessionId, self.fromBodyId, _dict(self.targetX, @"x", self.targetY, @"y"));
	}

	return params;
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.incoming = [result objectForKey:@"incoming"];
	self.available = [result objectForKey:@"available"];
	self.unavailabe = [result objectForKey:@"unavailable"];
	self.miningPlatforms = [result objectForKey:@"mining_platforms"];
}


- (NSString *)serviceUrl {
	return @"spaceport";
}


- (NSString *)methodName {
	return @"get_ships_for";
}


- (void)dealloc {
	self.fromBodyId = nil;
	self.targetBodyName = nil;
	self.targetBodyId = nil;
	self.targetStarName = nil;
	self.targetStarId = nil;
	self.targetX = nil;
	self.targetY = nil;
	self.incoming = nil;
	self.available = nil;
	self.unavailabe = nil;
	self.miningPlatforms = nil;
	[super dealloc];
}


@end
