//
//  LEBuildingRecycle.m
//  UniversalClient
//
//  Created by Kevin Runde on 5/13/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingRecycle.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingRecycle


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize energy;
@synthesize ore;
@synthesize water;
@synthesize subsidized;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl energy:(NSNumber *)inEnergy ore:(NSNumber *)inOre water:(NSNumber *)inWater subsidized:(BOOL)inSubsidized {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.energy = inEnergy;
	self.ore = inOre;
	self.water = inWater;
	self.subsidized = inSubsidized;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return array_([Session sharedInstance].sessionId, self.buildingId, self.water, self.ore, self.energy, self.subsidized);
}


- (void)processSuccess {
	//Does nothing
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"recycle";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.energy = nil;
	self.ore = nil;
	self.water = nil;
	[super dealloc];
}


@end
