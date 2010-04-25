//
//  LEBuildingAssignSpy.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingAssignSpy.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingAssignSpy


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize spyId;
@synthesize assignment;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl spyId:(NSString *)inSpyId assignment:(NSString *)inAssignment {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.spyId = inSpyId;
	self.assignment = inAssignment;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return array_([Session sharedInstance].sessionId, self.buildingId, self.spyId, self.assignment);
}


- (void)processSuccess {
	//Does nothing
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"assign_spy";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.spyId = nil;
	self.assignment = nil;
	[super dealloc];
}


@end
