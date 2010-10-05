//
//  AlliancePublicProfile.m
//  UniversalClient
//
//  Created by Kevin Runde on 10/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "AlliancePublicProfile.h"
#import "LEMacros.h"
#import "Util.h"
#import "AllianceMember.h"


@implementation AlliancePublicProfile


@synthesize id;
@synthesize name;
@synthesize publicDescription;
@synthesize leaderId;
@synthesize leaderName;
@synthesize dateCreated;
@synthesize influence;
@synthesize members;
@synthesize spaceStations;


#pragma mark -
#pragma mark NSObject Methods

- (void)dealloc {
	self.id = nil;
	self.name = nil;
	self.publicDescription = nil;
	self.leaderId = nil;
	self.leaderName = nil;
	self.dateCreated = nil;
	self.influence = nil;
	self.members = nil;
	self.spaceStations = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)parseData:(NSMutableDictionary *)data {
	self.id = [Util idFromDict:data named:@"id"];
	self.name = [data objectForKey:@"name"];
	self.publicDescription = [data objectForKey:@"description"];
	self.leaderId = [data objectForKey:@"leader_id"];
	self.dateCreated = [Util date:[data objectForKey:@"date_created"]];
	self.influence = [Util asNumber:[data objectForKey:@"influence"]];
	
	if (!self.members) {
		self.members = [NSMutableArray arrayWithCapacity:[[data objectForKey:@"members"] count]];
	} else {
		[self.members removeAllObjects];
	}
	for (NSMutableDictionary *allianceMemberData in [data objectForKey:@"members"]) {
		AllianceMember *allianceMember = [[AllianceMember alloc] init];
		[allianceMember parseData:allianceMemberData];
		[self.members addObject:allianceMember];
		
		if ([allianceMember.empireId isEqualToString:self.leaderId]) {
			self.leaderName = allianceMember.name;
		}
		
		[allianceMember release];
	}

	self.spaceStations = [data objectForKey:@"space_stations"];
}


@end
