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
@synthesize pageNumber;
@synthesize ships;
@synthesize numberOfShips;


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
	
	NSLog(@"Number of ships: %@", self.numberOfShips);
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
