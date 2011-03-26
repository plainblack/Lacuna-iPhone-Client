//
//  MyClass.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/26/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuildingViewShipsOrbiting.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "Ship.h"


@implementation LEBuildingViewShipsOrbiting


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize pageNumber;
@synthesize orbitingShips;
@synthesize numberOfShipsOrbiting;


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
	self.numberOfShipsOrbiting = [Util asNumber:[result objectForKey:@"number_of_ships"]];
	NSMutableArray *shipsOrbitingData = [result objectForKey:@"ships"];
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[shipsOrbitingData count]];
	Ship *travellingShip;
	
	for (NSDictionary *travellingShipData in shipsOrbitingData) {
		travellingShip = [[[Ship alloc] init] autorelease];
		[travellingShip parseData:travellingShipData];
		[tmp addObject:travellingShip];
	}
	[tmp sortUsingDescriptors:_array([[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease])];
	self.orbitingShips = tmp;
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
	self.orbitingShips = nil;
	self.numberOfShipsOrbiting = nil;
	[super dealloc];
}


@end
