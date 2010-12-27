//
//  LEBuildingPrepareExperiment.m
//  UniversalClient
//
//  Created by Kevin Runde on 12/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingPrepareExperiment.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingPrepareExperiment


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize grafts;
@synthesize survivalOdds;
@synthesize graftOdds;
@synthesize essentiaCost;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId);
}


- (void)processSuccess {
	NSMutableDictionary *result = [self.response objectForKey:@"result"];
	self.grafts = [result objectForKey:@"grafts"];
	self.survivalOdds = [Util asNumber:[result objectForKey:@"grafts"]];
	self.graftOdds = [Util asNumber:[result objectForKey:@"grafts"]];
	self.essentiaCost = [Util asNumber:[result objectForKey:@"grafts"]];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"prepare_experiment";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.grafts = nil;
	self.survivalOdds = nil;
	self.graftOdds = nil;
	self.essentiaCost = nil;
	[super dealloc];
}



@end
