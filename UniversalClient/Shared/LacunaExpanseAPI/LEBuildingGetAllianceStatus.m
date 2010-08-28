//
//  LEBuildingGetAllianceStatus.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingGetAllianceStatus.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingGetAllianceStatus


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize allianceStatus;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId);
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
	return @"get_alliance_status";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.allianceStatus = nil;
	[super dealloc];
}


@end
