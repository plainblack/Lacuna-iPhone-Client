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


@implementation LEGetBuildables


@synthesize bodyId;
@synthesize buildables;
@synthesize x;
@synthesize y;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget bodyId:(NSString *)inBodyId x:(NSNumber *)inX y:(NSNumber *)inY {
	self.bodyId = inBodyId;
	self.x = inX;
	self.y = inY;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSArray *params = array_([Session sharedInstance].sessionId, self.bodyId, self.x, self.y);
	return params;
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
	
	[self.buildables sortUsingDescriptors:array_([[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES])];
	
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
	[super dealloc];
}


@end
