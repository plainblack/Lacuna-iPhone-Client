//
//  LEBuildingBuildShip.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingBuildShip.h"
#import "LEMacros.h"
#import "Session.h"
#import "ShipBuildQueueItem.h"


@implementation LEBuildingBuildShip


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize shipType;
@synthesize shipBuildQueue;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl shipType:(NSString *)inShipType {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.shipType = inShipType;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, self.shipType);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	NSMutableArray *shipsTravellingData = [result objectForKey:@"ships_building"];
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[shipsTravellingData count]];
	ShipBuildQueueItem *shipBuildQueueItem;
	
	for (NSDictionary *shipBuildQueueItemData in shipsTravellingData) {
		shipBuildQueueItem = [[[ShipBuildQueueItem alloc] init] autorelease];
		[shipBuildQueueItem parseData:shipBuildQueueItemData];
		[tmp addObject:shipBuildQueueItem];
	}
	[tmp sortUsingDescriptors:_array([[[NSSortDescriptor alloc] initWithKey:@"dateCompleted" ascending:YES] autorelease])];
	self.shipBuildQueue = tmp;
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"build_ship";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.shipType = nil;
	self.shipBuildQueue = nil;
	[super dealloc];
}


@end
