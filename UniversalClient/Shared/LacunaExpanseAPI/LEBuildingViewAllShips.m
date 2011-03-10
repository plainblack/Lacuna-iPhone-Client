//
//  LEBuildingViewAllShips.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingViewAllShips.h"
#import "LEMacros.h"
#import "Util.h";
#import "Session.h"
#import "Ship.h";


@implementation LEBuildingViewAllShips


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize tag;
@synthesize task;
@synthesize ships;
@synthesize numberOfShips;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl tag:(NSString *)inTag task:(NSString *)inTask {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.tag = inTag;
	self.task = inTask;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	NSMutableDictionary *filter = [NSMutableDictionary dictionaryWithCapacity:2];
	if (self.tag) {
		[filter setObject:self.tag forKey:@"tag"];
	}
	if (self.task) {
		[filter setObject:self.task forKey:@"task"];
	}
	NSLog(@"View All Ships Filter: %@", filter);
	return _array([Session sharedInstance].sessionId, self.buildingId, _dict([NSDecimalNumber one], @"no_paging"), filter, @"name");
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.numberOfShips = [Util asNumber:[result objectForKey:@"number_of_ships"]];
	NSMutableArray *shipsData = [result objectForKey:@"ships"];
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[shipsData count]];
	Ship *ship;
	
	for (NSDictionary *shipData in shipsData) {
		ship = [[[Ship alloc] init] autorelease];
		[ship parseData:shipData];
		[tmp addObject:ship];
	}
	[tmp sortUsingDescriptors:_array([[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease])];
	self.ships = tmp;
	NSLog(@"Num Ships: %i", [self.ships count]);
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"view_all_ships";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.tag = nil;
	self.task = nil;
	self.ships = nil;
	[super dealloc];
}


@end
