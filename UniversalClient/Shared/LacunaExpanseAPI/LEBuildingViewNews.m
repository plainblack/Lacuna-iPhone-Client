//
//  LEBuildingViewNews.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingViewNews.h"
#import "Session.h"
#import "LEMacros.h"


@implementation LEBuildingViewNews


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize newsItems;


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
	self.newsItems = [result objectForKey:@"news"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"view_news";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.newsItems = nil;
	[super dealloc];
}


@end
