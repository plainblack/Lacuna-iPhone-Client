//
//  BaseMapItem.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "BaseMapItem.h"
#import "LEMacros.h"
#import "Util.h"


@implementation BaseMapItem


@synthesize id;
@synthesize type;
@synthesize name;
@synthesize x;
@synthesize y;
@synthesize stationId;
@synthesize stationName;
@synthesize stationX;
@synthesize stationY;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.id = nil;
	self.type = nil;
	self.name = nil;
	self.x = nil;
	self.y = nil;
    self.stationId = nil;
    self.stationName = nil;
    self.stationX = nil;
    self.stationY = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, type:%@, name:%@, x:%@, y:%@, stationId:%@, stationName:%@, stationX:%@, stationY:%@",
			self.id, self.type, self.name, self.x, self.y, self.stationId, self.stationName, self.stationX, self.stationY];
}


#pragma mark -
#pragma mark Instance Methods

- (void)parseData:(NSMutableDictionary *)data {
	self.id = [Util idFromDict:data named:@"id"];
	self.type = [data objectForKey:@"type"];
	self.name = [data objectForKey:@"name"];
	self.x = [Util asNumber:[data objectForKey:@"x"]];
	self.y = [Util asNumber:[data objectForKey:@"y"]];

    NSMutableDictionary *stationData = [data objectForKey:@"station"];
    if (isNotNull(data)) {
        self.stationId = [Util idFromDict:stationData named:@"id"];
        self.stationName = [stationData objectForKey:@"name"];
        self.stationX = [Util asNumber:[stationData objectForKey:@"x"]];
        self.stationY = [Util asNumber:[stationData objectForKey:@"y"]];
    } else {
        self.stationId = nil;
        self.stationName = nil;
        self.stationX = nil;
        self.stationY = nil;
    }
}


@end
