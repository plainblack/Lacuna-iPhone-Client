//
//  LEBuildingRenameSpecies.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/7/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuildingRenameSpecies.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingRenameSpecies


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize speciesName;
@synthesize speciesDescription;
@synthesize success;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl speciesName:(NSString *)inSpeciesName  speciesDescription:(NSString *)inSpeciesDescription {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
    self.speciesName = inSpeciesName;
    self.speciesDescription = inSpeciesDescription;
    
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId, _dict(self.speciesName, @"name", self.speciesDescription, @"description"));
	return params;
}


- (void)processSuccess {
    NSMutableDictionary *result = [self.response objectForKey:@"result"];
    self.success = _boolv([Util asNumber:[result objectForKey:@""]]);
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"rename_species";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
    self.speciesName = nil;
    self.speciesDescription = nil;
	[super dealloc];
}


@end
