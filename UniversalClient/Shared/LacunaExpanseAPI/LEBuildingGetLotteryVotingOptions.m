//
//  LEBuildingGetLotteryVotingOptions.m
//  UniversalClient
//
//  Created by Kevin Runde on 10/13/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingGetLotteryVotingOptions.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingGetLotteryVotingOptions


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize votingOptions;


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
	NSMutableArray *tmp = [result objectForKey:@"options"];
	[tmp sortUsingDescriptors:_array([[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease])];
	self.votingOptions = tmp;
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"get_lottery_view_options";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.votingOptions = nil;
	[super dealloc];
}


@end
