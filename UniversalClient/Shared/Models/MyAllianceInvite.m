//
//  MyAllianceInvite.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "MyAllianceInvite.h"
#import "Util.h"


@implementation MyAllianceInvite


@synthesize id;
@synthesize name;
@synthesize allianceId;


#pragma mark --
#pragma mark Object Methods

- (void)dealloc {
	self.id = nil;
	self.name = nil;
	self.allianceId = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, name:%@, allianceId: %@",
			self.id, self.name, self.allianceId];
}


#pragma mark --
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
	self.id = [data objectForKey:@"id"];
	self.name = [data objectForKey:@"name"];
	self.allianceId = [data objectForKey:@"alliance_id"];
}


@end
