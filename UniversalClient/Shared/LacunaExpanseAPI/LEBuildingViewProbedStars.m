//
//  LEBuildingViewProbedStars.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingViewProbedStars.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "Star.h"


@implementation LEBuildingViewProbedStars


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize probedStars;
@synthesize starCount;


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
	self.starCount = [Util asNumber:[result objectForKey:@"star_count"]];

	NSMutableArray *starsData = [result objectForKey:@"stars"];
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[starsData count]];
	Star  *star;
	
	for (NSDictionary *starData in starsData) {
		star = [[[Star alloc] init] autorelease];
		[star parseData:starData];
		[tmp addObject:star];
	}
	[tmp sortUsingDescriptors:_array([[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES])];
	self.probedStars = tmp;
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"get_probed_stars";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.probedStars = nil;
	self.starCount = nil;
	[super dealloc];
}


@end
