//
//  Ship.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Ship.h"
#import "LEMacros.h"


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
	return [NSString stringWithFormat:@"id:%@, name:%@, type:%@, task:%@, speed:%i, holdSize:%i", 
			self.id, self.name, self.type, self.task, self.speed, self.holdSize];
}


- (void)dealloc {
	self.id = nil;
	self.name = nil;
	self.type = nil;
	self.task = nil;
	[super dealloc];
}


#pragma mark --
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)shipData {
	self.id = [shipData objectForKey:@"id"];
	self.name = [shipData objectForKey:@"name"];
	self.type = [shipData objectForKey:@"type"];
	self.task = [shipData objectForKey:@"task"];
	self.speed = _intv([shipData objectForKey:@"speed"]);
	self.holdSize = _intv([shipData objectForKey:@"hold_size"]);
}


@end
