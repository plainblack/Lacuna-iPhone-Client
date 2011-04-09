//
//  LEBuildingProposeTransferStationOwnership.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/9/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuildingProposeTransferStationOwnership.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingProposeTransferStationOwnership


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize toEmpireId;
@synthesize results;
@synthesize proposition;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl toEmpireId:(NSString *)inToEmpireId {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
    self.toEmpireId = inToEmpireId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId, self.toEmpireId);
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
	return @"propose_transfer_station_ownership";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
    self.toEmpireId = nil;
    self.results = nil;
    self.proposition = nil;
	[super dealloc];
}


@end
