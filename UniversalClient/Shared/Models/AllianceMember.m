//
//  AllianceMember.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "AllianceMember.h"
#import "Util.h"


@implementation AllianceMember


@synthesize empireId;
@synthesize name;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.empireId = nil;
	self.name = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"empireId:%@, name:%@",
			self.empireId, self.name];
}


#pragma mark -
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
	self.empireId = [Util idFromDict:data named:@"empire_id"];
	if (!self.empireId) {
		self.empireId = [Util idFromDict:data named:@"id"];
	}
	self.name = [data objectForKey:@"name"];
}


@end
