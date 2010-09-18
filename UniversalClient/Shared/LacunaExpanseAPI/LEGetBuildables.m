//
//  LEGetBuildables.m
//  DKTest
//
//  Created by Kevin Runde on 3/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LEGetBuildables.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEGetBuildables


@synthesize bodyId;
@synthesize buildables;
@synthesize x;
@synthesize y;
@synthesize tag;
@synthesize buildQueueMaxSize;
@synthesize buildQueueSize;
@dynamic buildQueueHasSpace;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget bodyId:(NSString *)inBodyId x:(NSDecimalNumber *)inX y:(NSDecimalNumber *)inY  tag:(NSString *)inTag{
	self.bodyId = inBodyId;
	self.x = inX;
	self.y = inY;
	self.tag = inTag;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSArray *params = _array([Session sharedInstance].sessionId, self.bodyId, self.x, self.y, self.tag);
	return params;
}


#pragma mark --
#pragma mark Getters/Setters

- (BOOL)buildQueueHasSpace {
	return [self.buildQueueSize compare:self.buildQueueMaxSize] == NSOrderedAscending;
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	NSDictionary *buildableDict = [result objectForKey:@"buildable"];
	
	self.buildables = [NSMutableArray arrayWithCapacity:[result count]];
	for(NSString *buildingName in [buildableDict allKeys]) {
		NSMutableDictionary *building = [buildableDict objectForKey:buildingName];
		[building setObject:buildingName forKey:@"name"];
		[self.buildables addObject:building];
	}
	
	[self.buildables sortUsingDescriptors:_array([[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease])];
	
	NSDictionary *buildQueueData = [result objectForKey:@"build_queue"];
	self.buildQueueMaxSize = [Util asNumber:[buildQueueData objectForKey:@"max"]];
	self.buildQueueSize = [Util asNumber:[buildQueueData objectForKey:@"current"]];
	
	[result objectForKey:@"building"];
}


- (NSString *)serviceUrl {
	return @"body";
}


- (NSString *)methodName {
	return @"get_buildable";
}


- (void)dealloc {
	self.bodyId = nil;
	self.buildables = nil;
	self.x = nil;
	self.y = nil;
	self.tag = nil;
	self.buildQueueMaxSize = nil;
	self.buildQueueSize = nil;
	[super dealloc];
}


@end
