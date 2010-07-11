//
//  Spy.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/10/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Spy.h"
#import "LEMacros.h"
#import "Util.h"


@implementation Spy


@synthesize id;
@synthesize name;
@synthesize bodyId;
@synthesize bodyName;
@synthesize assignment;
@synthesize level;
@synthesize politicsExp;
@synthesize mayhemExp;
@synthesize theftExp;
@synthesize intelExp;
@synthesize defenseRating;
@synthesize offenseRating;
@synthesize isAvailable;
@synthesize secondsRemaining;
@synthesize assignmentStarted;
@synthesize assignmentEnds;



#pragma mark --
#pragma mark NSObject Methods

- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, name:%@, bodyId:%@, bodyName:%@, assignemtn:%@, level:%i, politicsExp:%i, mayhemExp:%i, theftExp:%i, intelExp:%i, offenseRating:%i, defenseRating:%i, isAvailable:%i, secondsRemaining:%i, assignmentStarted:%@, assignmentEnds:%@", 
			self.id, self.name, self.bodyId, self.bodyName, self.assignment, self.level, self.politicsExp, self.mayhemExp, self.theftExp, self.intelExp, self.offenseRating, self.defenseRating, self.isAvailable, self.secondsRemaining, self.assignmentStarted, self.assignmentEnds];
}


- (void)dealloc {
	self.id = nil;
	self.name = nil;
	self.bodyId = nil;
	self.bodyName = nil;
	self.assignment = nil;
	self.assignmentStarted = nil;
	self.assignmentEnds = nil;
	[super dealloc];
}


#pragma mark --
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)spyData {
	self.id = [spyData objectForKey:@"id"];
	self.name = [spyData objectForKey:@"name"];
	self.bodyId = [[spyData objectForKey:@"assigned_to"] objectForKey:@"body_id"];
	self.bodyName = [[spyData objectForKey:@"assigned_to"] objectForKey:@"name"];
	self.assignment = [spyData objectForKey:@"assignment"];
	
	self.level = _intv([spyData objectForKey:@"level"]);
	self.politicsExp = _intv([spyData objectForKey:@"politics"]);
	self.mayhemExp = _intv([spyData objectForKey:@"mayhem"]);
	self.theftExp = _intv([spyData objectForKey:@"theft"]);
	self.intelExp = _intv([spyData objectForKey:@"intel"]);
	self.offenseRating = _intv([spyData objectForKey:@"offense_rating"]);
	self.defenseRating = _intv([spyData objectForKey:@"defense_rating"]);
	
	self.isAvailable = [[spyData objectForKey:@"is_available"] boolValue];
	self.secondsRemaining = _intv([spyData objectForKey:@"seconds_remaining"]);
	self.assignmentStarted = [Util date:[spyData objectForKey:@"started_assignment"]];
	self.assignmentEnds = [Util date:[spyData objectForKey:@"available_on"] ];
}


- (BOOL)tick:(NSInteger)interval {
	if (secondsRemaining > 0) {
		self.secondsRemaining -= interval;
		if (secondsRemaining <= 0) {
			self.secondsRemaining = 0;
			return YES;
		}
	}
	
	return NO;
}


@end
