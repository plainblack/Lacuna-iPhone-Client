//
//  LEBuildingGetStar.m
//  UniversalClient
//
//  Created by Kevin Runde on 12/23/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingGetStar.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEBuildingGetStar


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize starId;
@synthesize star;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl starId:(NSString *)inStarId {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.starId = inStarId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return _array(session.sessionId, self.buildingId, self.starId);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.star = [result objectForKey:@"star"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"get_star";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.starId = nil;
	self.star = nil;
	[super dealloc];
}


@end
