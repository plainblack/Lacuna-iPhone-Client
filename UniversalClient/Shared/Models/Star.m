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


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.id = nil;
	self.color = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, color:%@, name:%@, x:%@, y:%@",
			self.id, self.color, self.name, self.x, self.y];
}


#pragma mark -
#pragma mark Instance Methods

- (void)parseData:(NSMutableDictionary *)data {
	[data setObject:@"star" forKey:@"type"];
	self.id = [Util idFromDict:data named:@"id"];
	[super parseData:data];
	self.color = [data objectForKey:@"color"];
}


@end
