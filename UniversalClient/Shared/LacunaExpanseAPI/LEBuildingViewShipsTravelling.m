//
//  LEBuildingViewShipsTravelling.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingViewShipsTravelling.h"
#import "LEMacros.h"
#import "Session.h"
#import "TravellingShip.h";


@implementation LEBuildingViewShipsTravelling


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize travellingShips;


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
	NSMutableArray *shipsTravellingData = [result objectForKey:@"ships_travelling"];
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[shipsTravellingData count]];
	TravellingShip *travellingShip;
	
	for (NSDictionary *travellingShipData in shipsTravellingData) {
		travellingShip = [[[TravellingShip alloc] init] autorelease];
		[travellingShip parseData:travellingShipData];
		[tmp addObject:travellingShip];
	}
	[tmp sortUsingDescriptors:_array([[[NSSortDescriptor alloc] initWithKey:@"dateArrives" ascending:YES] autorelease])];
	self.travellingShips = tmp;
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"view_ships_travelling";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.travellingShips = nil;
	[super dealloc];
}


@end
