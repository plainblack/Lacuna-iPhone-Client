//
//  LEBuildingThrowParty.m
//  UniversalClient
//
//  Created by Kevin Runde on 5/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingThrowParty.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingThrowParty


@synthesize buildingId;
@synthesize buildingUrl;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return array_([Session sharedInstance].sessionId, self.buildingId);
}


- (void)processSuccess {
	//Does nothing
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"throw_a_party";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	[super dealloc];
}


@end
