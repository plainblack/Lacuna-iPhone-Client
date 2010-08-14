//
//  LEBuildingViewSpies.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingViewSpies.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingViewSpies


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize pageNumber;
@synthesize spies;
@synthesize possibleAssignments;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl pageNumber:(NSInteger)inPageNumber {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.pageNumber = inPageNumber;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, [NSDecimalNumber numberWithInt:self.pageNumber]);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.spies = [result objectForKey:@"spies"];
	self.possibleAssignments = [result objectForKey:@"possible_assignments"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"view_spies";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.spies = nil;
	self.possibleAssignments = nil;
	[super dealloc];
}


@end
