//
//  AllianceStatus.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "AllianceStatus.h"
#import "LEMacros.h"
#import "Util.h"
#import "AllianceMember.h"


@implementation AllianceStatus


@synthesize id;
@synthesize name;
@synthesize leaderId;
@synthesize leaderName;
@synthesize forumUri;
@synthesize allianceDescription;
@synthesize announcements;
@synthesize dateCreated;
@synthesize members;


#pragma mark --
#pragma mark Object Methods


- (id)init {
	if (self = [super init]) {
		self.members = [NSMutableArray array];
	}
	
	return self;
}

- (void)dealloc {
	self.id = nil;
	self.name = nil;
	self.leaderId = nil;
	self.leaderName = nil;
	self.forumUri = nil;
	self.allianceDescription = nil;
	self.announcements = nil;
	self.dateCreated = nil;
	self.members = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, name:%@, leaderId: %@, leaderName:%@, forumUri: %@, description: %@, announcements: %@, dateCreated: %@, members: %@",
			self.id, self.name, self.leaderId, self.leaderName, self.forumUri, self.allianceDescription, self.announcements, self.dateCreated, self.members];
}


#pragma mark --
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
	self.id = [data objectForKey:@"id"];
	self.name = [data objectForKey:@"name"];
	self.leaderId = [data objectForKey:@"leader_id"];
	self.forumUri = [data objectForKey:@"forum_uri"];
	self.allianceDescription = [data objectForKey:@"description"];
	self.announcements = [data objectForKey:@"announcements"];
	self.dateCreated = [Util date:[data objectForKey:@"date_created"]];
	NSMutableArray *memberDataArray = [data objectForKey:@"members"];
	for (NSMutableDictionary *memberData in memberDataArray) {
		AllianceMember *allianceMember = [[[AllianceMember alloc] init] autorelease];
		[allianceMember parseData:memberData];
		[self.members addObject:allianceMember];
		if ([allianceMember.empireId isEqualToString:self.leaderId]) {
			self.leaderName = allianceMember.name;
		}
	}
	[self.members sortUsingDescriptors:_array([[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES])];
}


@end
