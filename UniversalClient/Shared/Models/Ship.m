//
//  Ship.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Ship.h"
#import "LEMacros.h"
#import "Util.h"


@implementation Ship


@synthesize id;
@synthesize name;
@synthesize type;
@synthesize task;
@synthesize speed;
@synthesize holdSize;


#pragma mark --
#pragma mark NSObject Methods

- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, name:%@, type:%@, task:%@, speed:%@, holdSize:%@", 
			self.id, self.name, self.type, self.task, self.speed, self.holdSize];
}


- (void)dealloc {
	self.id = nil;
	self.name = nil;
	self.type = nil;
	self.task = nil;
	self.speed = nil;
	self.holdSize = nil;
	[super dealloc];
}


#pragma mark --
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)shipData {
	self.id = [shipData objectForKey:@"id"];
	self.name = [shipData objectForKey:@"name"];
	self.type = [shipData objectForKey:@"type"];
	self.task = [shipData objectForKey:@"task"];
	self.speed = [Util asNumber:[shipData objectForKey:@"speed"]];
	self.holdSize = [Util asNumber:[shipData objectForKey:@"hold_size"]];
}


@end
