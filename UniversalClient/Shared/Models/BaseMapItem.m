//
//  BaseMapItem.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "BaseMapItem.h"
#import "Util.h"


@implementation BaseMapItem


@synthesize type;
@synthesize name;
@synthesize x;
@synthesize y;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.type = nil;
	self.name = nil;
	self.x = nil;
	self.y = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"type:%@, name:%@, x:%@, y:%@",
			self.type, self.name, self.x, self.y];
}


#pragma mark -
#pragma mark Instance Methods

- (void)parseData:(NSMutableDictionary *)data {
	self.type = [data objectForKey:@"type"];
	self.name = [data objectForKey:@"name"];
	self.x = [Util asNumber:[data objectForKey:@"x"]];
	self.y = [Util asNumber:[data objectForKey:@"y"]];
}


@end
