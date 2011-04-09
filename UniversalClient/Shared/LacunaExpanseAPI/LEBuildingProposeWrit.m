//
//  LEBuildingProposeWrit.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/9/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuildingProposeWrit.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingProposeWrit


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize title;
@synthesize descriptionText;
@synthesize results;
@synthesize proposition;



- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl title:(NSString *)inTitle description:(NSString *)inDescription {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
    self.title = inTitle;
    self.descriptionText = inDescription;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId, self.title, self.descriptionText);
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
	return @"propose_writ";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
    self.title = nil;
    self.descriptionText = nil;
    self.results = nil;
    self.proposition = nil;
	[super dealloc];
}


@end
