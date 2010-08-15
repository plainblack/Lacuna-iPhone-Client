//
//  LEBuildingViewPlatforms.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/1/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingViewPlatforms.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "MiningPlatform.h"


@implementation LEBuildingViewPlatforms


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize platforms;
@synthesize maxPlatforms;


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
	self.maxPlatforms = [Util asNumber:[result objectForKey:@"max_platforms"]];
	
	NSMutableArray *platformsData = [result objectForKey:@"platforms"];
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[platformsData count]];
	MiningPlatform  *miningPlatform;
	
	for (NSDictionary *platformData in platformsData) {
		miningPlatform = [[[MiningPlatform alloc] init] autorelease];
		[miningPlatform parseData:platformData];
		[tmp addObject:miningPlatform];
	}
	[tmp sortUsingDescriptors:_array([[NSSortDescriptor alloc] initWithKey:@"asteroidName" ascending:YES])];
	self.platforms = tmp;
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"view_platforms";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.platforms = nil;
	self.maxPlatforms = nil;
	[super dealloc];
}


@end
