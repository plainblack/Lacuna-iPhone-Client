//
//  LEBuildingViewForeignSpies.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/6/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingViewForeignSpies.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingViewForeignSpies


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize pageNumber;
@synthesize foreignSpies;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl pageNumber:(NSInteger)inPageNumber {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.pageNumber = inPageNumber;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, [NSNumber numberWithInt:self.pageNumber]);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	
	self.foreignSpies = [result objectForKey:@"spies"];
	NSLog(@"Foreign Spies: %@", self.foreignSpies);
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"view_foreign_spies";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.foreignSpies = nil;
	[super dealloc];
}


@end
