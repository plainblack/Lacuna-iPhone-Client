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
@synthesize forumUri;
@synthesize description;
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
	self.forumUri = nil;
	self.description = nil;
	self.announcements = nil;
	self.dateCreated = nil;
	self.members = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, name:%@, leaderId: %@, forumUri: %@, description: %@, announcements: %@, dateCreated: %@, members: %@",
			self.id, self.name, self.leaderId, self.forumUri, self.description, self.announcements, self.dateCreated, self.members];
}


#pragma mark --
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
	self.id = [data objectForKey:@"id"];
	self.name = [data objectForKey:@"name"];
	self.leaderId = [data objectForKey:@"leaderId"];
	self.forumUri = [data objectForKey:@"forumUri"];
	self.description = [data objectForKey:@"description"];
	self.announcements = [data objectForKey:@"announcements"];
	self.dateCreated = [data objectForKey:@"dateCreated"];
	NSMutableArray *memberDataArray = [data objectForKey:@"members"];
	for (NSMutableDictionary *memberData in memberDataArray) {
		AllianceMember *allianceMember = [[[AllianceMember alloc] init] autorelease];
		[allianceMember parseData:memberData];
		[self.members addObject:allianceMember];
	}
	[self.members sortUsingDescriptors:_array([[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES])];
}


@end
