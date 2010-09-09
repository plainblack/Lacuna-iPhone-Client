//
//  LEBuildingViewAllShips.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingViewAllShips.h"
#import "LEMacros.h"
#import "Session.h"
#import "Ship.h";


@implementation LEBuildingViewAllShips


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize ships;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
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
	self.ships = nil;
	[super dealloc];
}


@end
