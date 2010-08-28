//
//  PendingAllianceInvite.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "PendingAllianceInvite.h"
#import "Util.h"


@implementation PendingAllianceInvite


@synthesize id;
@synthesize name;
@synthesize empireId;


#pragma mark --
#pragma mark Object Methods

- (void)dealloc {
	self.id = nil;
	self.name = nil;
	self.empireId = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, name:%@, empireId: %@",
			self.id, self.name, self.empireId];
}


#pragma mark --
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
	self.id = [Util idFromDict:data named:@"id"];
	self.name = [data objectForKey:@"name"];
	self.empireId = [data objectForKey:@"empire_id"];
}


@end
