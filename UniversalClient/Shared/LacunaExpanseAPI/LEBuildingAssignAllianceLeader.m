//
//  LEBuildingAssignAllianceLeader.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingAssignAllianceLeader.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingAssignAllianceLeader


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize newLeaderId;
@synthesize allianceStatus;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl newLeaderId:(NSString *)inNewLeaderId {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.newLeaderId = inNewLeaderId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, self.newLeaderId);
}


- (void)processSuccess {
	self.allianceStatus = [self.response objectForKey:@"alliance"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"assign_alliance_leader";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.newLeaderId = nil;
	self.allianceStatus = nil;
	[super dealloc];
}


@end
