//
//  LEBuildingViewForeignShips.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/12/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingViewForeignShips.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "TravellingShip.h";


@implementation LEBuildingViewForeignShips


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize pageNumber;
@synthesize foreignShips;
@synthesize numberOfShipsForeign;


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
	self.numberOfShipsForeign = [Util asNumber:[result objectForKey:@"number_of_ships"]];
	NSMutableArray *shipsForeignData = [result objectForKey:@"ships"];
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[shipsForeignData count]];
	TravellingShip *travellingShip;
	
	for (NSDictionary *travellingShipData in shipsForeignData) {
		travellingShip = [[[TravellingShip alloc] init] autorelease];
		[travellingShip parseData:travellingShipData];
		[tmp addObject:travellingShip];
	}
	[tmp sortUsingDescriptors:_array([[[NSSortDescriptor alloc] initWithKey:@"dateArrives" ascending:YES] autorelease])];
	self.foreignShips = tmp;
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"view_foreign_ships";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.foreignShips = nil;
	self.numberOfShipsForeign = nil;
	[super dealloc];
}


@end
