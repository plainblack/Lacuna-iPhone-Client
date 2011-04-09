//
//  LEBuildingProposeRenameStar.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/9/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuildingProposeRenameStar.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingProposeRenameStar


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize starId;
@synthesize name;
@synthesize results;
@synthesize proposition;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl starId:(NSString *)inStarId name:(NSString *)inName{
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
    self.starId = inStarId;
    self.name = inName;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId, self.starId, self.name);
	return params;
}


- (void)processSuccess {
    self.results = [self.response objectForKey:@"result"];
    self.proposition = [self.results objectForKey:@"proposition"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"propose_rename_star";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
    self.starId = nil;
    self.name = nil;
    self.results = nil;
    self.proposition = nil;
	[super dealloc];
}


@end
