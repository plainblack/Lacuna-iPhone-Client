//
//  LEBuildingRenameEmpire.m
//  UniversalClient
//
//  Created by Kevin Runde on 11/16/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingRenameEmpire.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingRenameEmpire


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize empireName;
@synthesize oldEmpireName;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl newEmpireName:(NSString *)inNewEmpireName {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.empireName = inNewEmpireName;
	Session *session = [Session sharedInstance];
	self.oldEmpireName = session.empire.name;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, self.empireName);
}


- (void)processSuccess {
	Session *session = [Session sharedInstance];
	[session renameSavedEmpireNameFrom:self.oldEmpireName to:self.empireName];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"rename_empire";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.oldEmpireName = nil;
	self.empireName = nil;
	[super dealloc];
}


@end
