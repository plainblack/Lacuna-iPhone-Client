//
//  LEBuildingResearchSpecies.m
//  UniversalClient
//
//  Created by Kevin Runde on 11/21/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingResearchSpecies.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingResearchSpecies


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize empireId;
@synthesize speciesData;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl empireId:(NSString *)inEmpireId {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.empireId = inEmpireId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, self.empireId);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.speciesData = [result objectForKey:@"species"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"research_species";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.empireId = nil;
	self.speciesData = nil;
	[super dealloc];
}


@end
