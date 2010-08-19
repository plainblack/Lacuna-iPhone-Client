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
@synthesize	extendedBuildLevel;


#pragma mark --
#pragma mark Object Methods

- (void)dealloc {
	self.id = nil;
	self.name = nil;
	self.buildLevel = nil;
	self.extendedBuildLevel = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, name:%@, buildLevel: %@, extendedBuildLevel: %@",
			self.id, self.name, self.buildLevel, self.extendedBuildLevel];
}


#pragma mark --
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
	self.id = [data objectForKey:@"id"];
	self.name = [data objectForKey:@"name"];
	self.buildLevel = [Util	asNumber:[data objectForKey:@"level"]];
	self.extendedBuildLevel = [Util	asNumber:[data objectForKey:@"extended_build_level"]];
	if ([self.extendedBuildLevel isEqual:[NSDecimalNumber zero]]) {
		self.extendedBuildLevel = nil;
	}
}


@end
