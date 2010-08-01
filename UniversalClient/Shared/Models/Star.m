//
//  Star.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Star.h"
#import "LEMacros.h"


@implementation Star


@synthesize id;
@synthesize color;
@synthesize name;
@synthesize x;
@synthesize y;
@synthesize z;


#pragma mark --
#pragma mark Object Methods

- (void)dealloc {
	self.id = nil;
	self.color = nil;
	self.name = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, color:%@, name:%@, x:%i, y:%i z:%i",
			self.id, self.color, self.name, self.x, self.y, self.z];
}


#pragma mark --
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
	self.id = [data objectForKey:@"id"];
	self.color = [data objectForKey:@"color"];
	self.name = [data objectForKey:@"name"];
	self.x = _intv([data objectForKey:@"x"]);
	self.y = _intv([data objectForKey:@"y"]);
	self.z = _intv([data objectForKey:@"z"]);
}


@end
