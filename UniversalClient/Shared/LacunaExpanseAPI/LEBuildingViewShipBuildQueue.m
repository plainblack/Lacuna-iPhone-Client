//
//  LEBuildingViewShipBuildQueue.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingViewShipBuildQueue.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "ShipBuildQueueItem.h"


@implementation LEBuildingViewShipBuildQueue


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize shipBuildQueue;
@synthesize numberShipBuilding;


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
	return @"view_build_queue";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.shipBuildQueue = nil;
	self.numberShipBuilding = nil; //KEVIN THIS IS NOT USED?
	[super dealloc];
}


@end
