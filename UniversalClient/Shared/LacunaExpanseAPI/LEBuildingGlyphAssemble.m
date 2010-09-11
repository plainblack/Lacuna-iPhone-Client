//
//  LEBuildingGlyphAssemble.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingGlyphAssemble.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingGlyphAssemble


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize glyphIds;
@synthesize itemName;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl glyphIds:(NSArray *)inGlyphIds {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.glyphIds = inGlyphIds;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId, self.glyphIds);
	
	return params;
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.itemName = [result objectForKey:@"item_name"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"assemble_glyphs";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.glyphIds = nil;
	self.itemName = nil;
	[super dealloc];
}


@end
