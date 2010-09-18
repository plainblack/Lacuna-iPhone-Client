//
//  LEBuildingGlyphSearch.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingGlyphSearch.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingGlyphSearch


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize oreType;
@synthesize secondsRemaining;
@synthesize result;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl oreType:(NSString *)inOreType {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.oreType = inOreType;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, oreType);
}


- (void)processSuccess {
	self.result = [self.response objectForKey:@"result"];
	self.secondsRemaining = _intv([self.result objectForKey:@"seconds_remaining"]);
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"search_for_glyph";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.oreType = nil;
	[super dealloc];
}


@end
