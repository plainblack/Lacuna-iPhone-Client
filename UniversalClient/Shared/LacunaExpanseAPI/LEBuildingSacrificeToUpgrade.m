//
//  LEBuildingSacrificeToUpgrade.m
//  UniversalClient
//
//  Created by Kevin Runde on 11/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingSacrificeToUpgrade.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingSacrificeToUpgrade


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize upgradeBuildingId;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl upgradeBuildingId:(NSString *)inUpgradeBuildingId {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.upgradeBuildingId = inUpgradeBuildingId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, self.upgradeBuildingId);
}


- (void)processSuccess {
	NSMutableDictionary *result = [self.response objectForKey:@"result"];
	NSLog(@"Sacrifice to upgrade result: %@", result);
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"sacrifice_to_upgrade";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.upgradeBuildingId = nil;
	[super dealloc];
}


@end
