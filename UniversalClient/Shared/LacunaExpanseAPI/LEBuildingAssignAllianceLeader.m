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


@synthesize buildingId = _buildingId;
@synthesize buildingUrl = _buildingUrl;
@synthesize leaderId = _leaderId;
@synthesize allianceStatus = _allianceStatus;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl newLeaderId:(NSString *)leaderId {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.leaderId = leaderId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, self.leaderId);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.allianceStatus = [result objectForKey:@"alliance_status"];
	if (!self.allianceStatus) {
		self.allianceStatus = [result objectForKey:@"alliance"];
	}
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
	self.leaderId = nil;
	self.allianceStatus = nil;
	[super dealloc];
}


@end
