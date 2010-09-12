//
//  LEBuildingViewShipsTravelling.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingViewShipsTravelling.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "Ship.h";


@implementation LEBuildingViewShipsTravelling


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize pageNumber;
@synthesize travellingShips;
@synthesize numberOfShipsTravelling;


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
	self.numberOfShipsTravelling = [Util asNumber:[result objectForKey:@"number_of_ships_travelling"]];
	NSMutableArray *shipsTravellingData = [result objectForKey:@"ships_travelling"];
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[shipsTravellingData count]];
	Ship *travellingShip;
	
	for (NSDictionary *travellingShipData in shipsTravellingData) {
		travellingShip = [[[Ship alloc] init] autorelease];
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
	self.numberOfShipsTravelling = nil;
	[super dealloc];
}


@end
