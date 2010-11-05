//
//  Mission.m
//  UniversalClient
//
//  Created by Kevin Runde on 11/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Mission.h"
#import "LEMacros.h"
#import	"Util.h"


@implementation Mission


@synthesize	id;
@synthesize	maxUniversityLevel;
@synthesize	datePosted;
@synthesize	name;
@synthesize	description;
@synthesize	objectives;
@synthesize	rewards;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.id = nil;
	self.maxUniversityLevel = nil;
	self.datePosted = nil;
	self.name = nil;
	self.description = nil;
	self.objectives = nil;
	self.rewards = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, maxUniversityLevel:%@, datePosted:%@, name:%@, description:%@, objectives:%@, rewards:%@",
			self.id, self.maxUniversityLevel, self.datePosted, self.name, self.description, self.objectives, self.rewards];
}


#pragma mark -
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
	self.id = [Util idFromDict:data named:@"id"];
	self.maxUniversityLevel = [Util asNumber:[data objectForKey:@"max_university_level"]];
	self.datePosted = [Util date:[data objectForKey:@"date_posted"]];
	self.name = [data objectForKey:@"name"];
	self.description = [data objectForKey:@"description"];
	self.objectives = [data objectForKey:@"objectives"];
	self.rewards = [data objectForKey:@"rewards"];
}


@end
