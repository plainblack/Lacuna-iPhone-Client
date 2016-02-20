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
@synthesize possibleAssignments;
@synthesize numOffensiveMissions;
@synthesize numDefensiveMissions;



#pragma mark -
#pragma mark NSObject Methods

- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, name:%@, bodyId:%@, bodyName:%@, assignemtn:%@, level:%@, politicsExp:%@, mayhemExp:%@, theftExp:%@, intelExp:%@, offenseRating:%@, defenseRating:%@, isAvailable:%i, secondsRemaining:%li, assignmentStarted:%@, assignmentEnds:%@, possibleAssignments:%@, numOffensiveMissions:%@, numDefensiveMissions:%@", 
			self.id, self.name, self.bodyId, self.bodyName, self.assignment, self.level, self.politicsExp, self.mayhemExp, self.theftExp, self.intelExp, self.offenseRating, self.defenseRating, self.isAvailable, (long)self.secondsRemaining, self.assignmentStarted, self.assignmentEnds, self.possibleAssignments, self.numOffensiveMissions, self.numDefensiveMissions];
}


- (void)dealloc {
	self.id = nil;
	self.name = nil;
	self.bodyId = nil;
	self.bodyName = nil;
	self.assignment = nil;
	self.level = nil;
	self.politicsExp = nil;
	self.mayhemExp = nil;
	self.theftExp = nil;
	self.intelExp = nil;
	self.defenseRating = nil;
	self.offenseRating = nil;
	self.assignmentStarted = nil;
	self.assignmentEnds = nil;
	self.possibleAssignments = nil;
	self.numOffensiveMissions = nil;
	self.numDefensiveMissions = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)spyData {
	self.id = [Util idFromDict:spyData named:@"id"];
	self.name = [spyData objectForKey:@"name"];
	self.bodyId = [[spyData objectForKey:@"assigned_to"] objectForKey:@"body_id"];
	self.bodyName = [[spyData objectForKey:@"assigned_to"] objectForKey:@"name"];
	self.assignment = [spyData objectForKey:@"assignment"];
	
	self.level = [Util asNumber:[spyData objectForKey:@"level"] ];
	self.politicsExp = [Util asNumber:[spyData objectForKey:@"politics"]];
	self.mayhemExp = [Util asNumber:[spyData objectForKey:@"mayhem"] ];
	self.theftExp = [Util asNumber:[spyData objectForKey:@"theft"] ];
	self.intelExp = [Util asNumber:[spyData objectForKey:@"intel"] ];
	self.offenseRating = [Util asNumber:[spyData objectForKey:@"offense_rating"] ];
	self.defenseRating = [Util asNumber:[spyData objectForKey:@"defense_rating"] ];
	
	self.isAvailable = [[spyData objectForKey:@"is_available"] boolValue];
	self.secondsRemaining = _intv([spyData objectForKey:@"seconds_remaining"]);
	self.assignmentStarted = [Util date:[spyData objectForKey:@"started_assignment"]];
	self.assignmentEnds = [Util date:[spyData objectForKey:@"available_on"] ];
	
	self.possibleAssignments = [spyData objectForKey:@"possible_assignments"];
	
	NSMutableDictionary *missionCountData = [spyData objectForKey:@"mission_count"];
	self.numOffensiveMissions = [Util asNumber:[missionCountData objectForKey:@"offensive"]];
	self.numDefensiveMissions = [Util asNumber:[missionCountData objectForKey:@"defensive"]];
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
