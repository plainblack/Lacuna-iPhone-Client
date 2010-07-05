//
//  LEBuildingRestrictCoverage.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingRestrictCoverage.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingRestrictCoverage

@synthesize buildingId;
@synthesize buildingUrl;
@synthesize isRestricted;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl restricted:(BOOL)restricted {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.isRestricted = restricted;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	if (self.isRestricted) {
		return _array([Session sharedInstance].sessionId, self.buildingId, [NSNumber numberWithInt:1]);
	} else {
		return _array([Session sharedInstance].sessionId, self.buildingId, [NSNumber numberWithInt:0]);
	}

}


- (void)processSuccess {
	//Does nothing special for now.
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"restrict_coverage";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	[super dealloc];
}


@end
