//
//  LEBuildingProposeRepealLaw.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/8/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuildingProposeRepealLaw.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingProposeRepealLaw


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize lawId;
@synthesize proposition;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl lawId:(NSString *)inLawId {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
    self.lawId = inLawId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId);
	return params;
}


- (void)processSuccess {
	NSMutableDictionary *result = [self.response objectForKey:@"result"];
    self.proposition = [result objectForKey:@"proposition"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"propose_repeal_law";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
    self.lawId = nil;
    self.proposition = nil;
	[super dealloc];
}


@end
