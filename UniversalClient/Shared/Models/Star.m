//
//  Star.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Star.h"
#import "LEMacros.h"
#import "Util.h"


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
	self.x = nil;
	self.y = nil;
	self.z = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, color:%@, name:%@, x:%@, y:%@ z:%@",
			self.id, self.color, self.name, self.x, self.y, self.z];
}


#pragma mark --
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
	self.id = [data objectForKey:@"id"];
	self.color = [data objectForKey:@"color"];
	self.name = [data objectForKey:@"name"];
	self.x = [Util asNumber:[data objectForKey:@"x"]];
	self.y = [Util asNumber:[data objectForKey:@"y"]];
	self.z = [Util asNumber:[data objectForKey:@"z"]];
}


@end
