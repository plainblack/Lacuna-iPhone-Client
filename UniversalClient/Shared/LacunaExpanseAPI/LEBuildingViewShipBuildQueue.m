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
@synthesize pageNumber;
@synthesize shipBuildQueue;
@synthesize numberShipBuilding;
@synthesize subsidizeBuildCost;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl pageNumber:(NSInteger)inPageNumber {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.pageNumber = inPageNumber;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, [NSDecimalNumber numberWithInt:self.pageNumber]);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	NSMutableArray *shipsBuildingData = [result objectForKey:@"ships_building"];
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[shipsBuildingData count]];
	ShipBuildQueueItem *shipBuildQueueItem;
	
	for (NSDictionary *shipBuildQueueItemData in shipsBuildingData) {
		shipBuildQueueItem = [[[ShipBuildQueueItem alloc] init] autorelease];
		[shipBuildQueueItem parseData:shipBuildQueueItemData];
		[tmp addObject:shipBuildQueueItem];
	}
	[tmp sortUsingDescriptors:_array([[[NSSortDescriptor alloc] initWithKey:@"dateCompleted" ascending:YES] autorelease])];
	self.shipBuildQueue = tmp;
    self.numberShipBuilding = [Util asNumber:[result objectForKey:@"number_of_ships_building"]];
    self.subsidizeBuildCost = [Util asNumber:[result objectForKey:@"cost_to_subsidize"]];
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
	self.numberShipBuilding = nil;
    self.subsidizeBuildCost = nil;
	[super dealloc];
}


@end
