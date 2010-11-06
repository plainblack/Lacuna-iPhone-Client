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
@synthesize	missionDescription;
@synthesize	objectives;
@synthesize	rewards;
@dynamic objectivesAsText;
@dynamic rewardsAsText;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.id = nil;
	self.maxUniversityLevel = nil;
	self.datePosted = nil;
	self.name = nil;
	self.missionDescription = nil;
	self.objectives = nil;
	self.rewards = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, maxUniversityLevel:%@, datePosted:%@, name:%@, missionDescription:%@, objectives:%@, rewards:%@",
			self.id, self.maxUniversityLevel, self.datePosted, self.name, self.missionDescription, self.objectives, self.rewards];
}


#pragma mark -
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
	self.id = [Util idFromDict:data named:@"id"];
	self.maxUniversityLevel = [Util asNumber:[data objectForKey:@"max_university_level"]];
	self.datePosted = [Util date:[data objectForKey:@"date_posted"]];
	self.name = [data objectForKey:@"name"];
	self.missionDescription = [data objectForKey:@"description"];
	self.objectives = [data objectForKey:@"objectives"];
	self.rewards = [data objectForKey:@"rewards"];
}


- (NSString *)objectivesAsText {
	NSString *tmp = [self.objectives componentsJoinedByString:@"; "];
	tmp = [tmp stringByReplacingOccurrencesOfString:@".;" withString:@";"];
	return tmp;
}


- (NSString *)rewardsAsText {
	NSString *tmp = [self.rewards componentsJoinedByString:@"; "];
	tmp = [tmp stringByReplacingOccurrencesOfString:@".;" withString:@";"];
	return tmp;
}


@end
