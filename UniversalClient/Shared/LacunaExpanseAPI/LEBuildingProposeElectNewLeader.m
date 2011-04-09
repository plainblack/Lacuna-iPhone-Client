//
//  LEBuildingProposeElectNewLeader.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/9/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuildingProposeElectNewLeader.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingProposeElectNewLeader


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize empireId;
@synthesize results;
@synthesize proposition;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl empireId:(NSString *)inEmpireId {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
    self.empireId = inEmpireId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId, self.empireId);
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
	return @"propose_elect_new_leader";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
    self.empireId = nil;
    self.results = nil;
    self.proposition = nil;
	[super dealloc];
}


@end
