//
//  LEBuildingProposeTaxation.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/9/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuildingProposeTaxation.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingProposeTaxation


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize taxAmount;
@synthesize results;
@synthesize proposition;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl taxAmount:(NSDecimalNumber *)inTaxAmount {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
    self.taxAmount = inTaxAmount;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId, self.taxAmount);
	return params;
}


- (void)processSuccess {
    self.results = [self.response objectForKey:@"result"];
    self.proposition = [self.results objectForKey:@"proposition"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"propose_taxation";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
    self.taxAmount = nil;
    self.results = nil;
    self.proposition = nil;
	[super dealloc];
}


@end
