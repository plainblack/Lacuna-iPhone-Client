//
//  LEBuildingCastVote.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/21/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuildingCastVote.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEBuildingCastVote


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize vote;
@synthesize propositionId;
@synthesize proposition;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl propositionId:(NSString *)inPropositionId vote:(BOOL)inVote {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
    self.propositionId = inPropositionId;
    self.vote = inVote;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId, self.propositionId, self.vote?[NSDecimalNumber one]:[NSDecimalNumber zero]);
	return params;
}


- (void)processSuccess {
	NSMutableDictionary *result = [self.response objectForKey:@"result"];
    self.proposition = [result objectForKey:@"proposition"];
    NSLog(@"Result of vote: %@", result);
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"cast_vote";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
    self.propositionId = nil;
    self.proposition = nil;
	[super dealloc];
}


@end
