//
//  ShipBuildQueueItem.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ShipBuildQueueItem.h"
#import "Util.h"


@implementation ShipBuildQueueItem


@synthesize type;
@synthesize dateCompleted;


#pragma mark -
#pragma mark NSObject Methods

- (NSString *)description {
	return [NSString stringWithFormat:@"type:%@, dateCompleted:%@", self.type, self.dateCompleted];
}


- (void)dealloc {
	self.type = nil;
	self.dateCompleted = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)shipData {
	self.type = [shipData objectForKey:@"type"];
	self.dateCompleted = [Util date:[shipData objectForKey:@"date_completed"]];
}


@end
