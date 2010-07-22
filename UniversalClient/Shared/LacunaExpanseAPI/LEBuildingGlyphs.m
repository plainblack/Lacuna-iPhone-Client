//
//  LEBuildingGlyphs.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingGlyphs.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingGlyphs


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize glyphs;


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
	self.glyphs = [result objectForKey:@"glyphs"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"get_glyphs";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.glyphs = nil;
	[super dealloc];
}


@end
