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
@synthesize propositions;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl propositionId:(NSString *)inPropositionId vote:(BOOL)inVote {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
    self.propositionId = inPropositionId;
    self.vote = inVote;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId);
	return params;
}


- (void)processSuccess {
	NSMutableDictionary *result = [self.response objectForKey:@"result"];
    self.propositions = [result objectForKey:@"propositions"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"view_propositions";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
    self.propositionId = nil;
    self.propositions = nil;
	[super dealloc];
}


@end
