//
//  Plan.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Plan.h"
#import "Util.h"


@implementation Plan


@synthesize	id;
@synthesize	name;
@synthesize	buildLevel;
@synthesize	extraBuildLevel;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.id = nil;
	self.name = nil;
	self.buildLevel = nil;
	self.extraBuildLevel = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, name:%@, buildLevel: %@, extraBuildLevel: %@",
			self.id, self.name, self.buildLevel, self.extraBuildLevel];
}


#pragma mark -
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
	self.id = [Util idFromDict:data named:@"id"];
	self.name = [data objectForKey:@"name"];
	self.buildLevel = [Util	asNumber:[data objectForKey:@"level"]];
	self.extraBuildLevel = [Util asNumber:[data objectForKey:@"extra_build_level"]];
	if ([self.extraBuildLevel isEqual:[NSDecimalNumber zero]]) {
		self.extraBuildLevel = nil;
	}
}


@end
