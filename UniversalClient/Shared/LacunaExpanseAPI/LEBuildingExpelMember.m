//
//  LEBuildingExpelMember.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingExpelMember.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingExpelMember


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize empireId;
@synthesize message;
@synthesize allianceStatus;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl empireId:(NSString *)inEmpireId message:(NSString *)inMessage {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.empireId = inEmpireId;
	self.message = inMessage;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId, self.empireId);
	if (self.message) {
		[params addObject:self.message];
	}
	return params;
}


- (void)processSuccess {
	self.allianceStatus = [self.response objectForKey:@"alliance_status"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"expel_member";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.empireId = nil;
	self.message = nil;
	self.allianceStatus = nil;
	[super dealloc];
}


@end
