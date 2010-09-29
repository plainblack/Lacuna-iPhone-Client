//
//  StarMap.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "StarMap.h"
#import "LEMacros.h"
#import "LEMapGetStars.h"
#import "BaseMapItem.h"
#import "Star.h"
#import "Body.h"

#define SECTOR_SIZE [NSDecimalNumber decimalNumberWithString:@"20"]


@interface StarMap (PrivateMethods)

- (void)loadSectorX:(NSDecimalNumber *)sectorX sectorY:(NSDecimalNumber *)sectorY;
- (NSDecimalNumber *)gridToSector:(NSDecimalNumber *)gridValue;
- (void)addMapItem:(BaseMapItem *)mapItem gridX:(NSDecimalNumber *)gridX girdY:(NSDecimalNumber *)gridY;

@end


@implementation StarMap


@synthesize sectors;
@synthesize lastUpdate;


# pragma -
#pragma mark NSObject Methods

- (id)init {
    if (self = [super init]) {
		self.sectors = [[[NSCache alloc] init] autorelease];
	}
	return self;
}

- (void)dealloc {
	self.sectors = nil;
	self.lastUpdate = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (BaseMapItem *)gridX:(NSDecimalNumber *)gridX gridY:(NSDecimalNumber *)gridY {
	NSDecimalNumber *sectorX = [self gridToSector:gridX];
	NSDecimalNumber *sectorY = [self gridToSector:gridY];
	NSString *sectorKey = [NSString stringWithFormat:@"%@x%@", sectorX, sectorY];
	NSDictionary *sector = [self.sectors objectForKey:sectorKey];

	if (sector) {
		NSDate *loadedAt = [sector objectForKey:@"loadedAt"];
		if (loadedAt) {
			NSString *gridKey = [NSString stringWithFormat:@"%@x%@", gridX, gridY];
			BaseMapItem *cell = [sector objectForKey:gridKey];
			return cell;
		} else {
			NSString *gridKey = [NSString stringWithFormat:@"%@x%@", gridX, gridY];
			BaseMapItem *cell = [sector objectForKey:gridKey];
			if (isNotNull(cell)) {
				return cell;
			} else {
				return nil;
			}
		}
	} else {
		[self loadSectorX:sectorX sectorY:sectorY];
		return nil;
	}

}


#pragma mark -
#pragma mark PrivateMethods

- (void)loadSectorX:(NSDecimalNumber *)sectorX sectorY:(NSDecimalNumber *)sectorY {
	NSString *sectorKey = [NSString stringWithFormat:@"%@x%@", sectorX, sectorY];
	NSLog(@"Loading %@", sectorKey);
	NSDecimalNumber *topLeftX = [sectorX decimalNumberByMultiplyingBy:SECTOR_SIZE];
	NSDecimalNumber *topLeftY = [[sectorY decimalNumberByMultiplyingBy:SECTOR_SIZE] decimalNumberByAdding:SECTOR_SIZE];
	NSDecimalNumber *bottomRightX = [[sectorX decimalNumberByMultiplyingBy:SECTOR_SIZE] decimalNumberByAdding:SECTOR_SIZE];
	NSDecimalNumber *bottomRightY = [sectorY decimalNumberByMultiplyingBy:SECTOR_SIZE];
	
	[[[LEMapGetStars alloc] initWithCallback:@selector(sectorLoaded:) target:self topLeftX:topLeftX topLeftY:topLeftY bottomRightX:bottomRightX bottomRightY:bottomRightY] autorelease];
	[self.sectors setObject:[NSMutableDictionary dictionaryWithCapacity:10] forKey:sectorKey];
}


- (NSDecimalNumber *)gridToSector:(NSDecimalNumber *)gridValue {
	NSDecimalNumber *tmp = [gridValue decimalNumberByDividingBy:SECTOR_SIZE];
	NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:0 raiseOnExactness:FALSE raiseOnOverflow:TRUE raiseOnUnderflow:TRUE raiseOnDivideByZero:TRUE]; 
	tmp = [tmp decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
	return tmp;
}

- (void)addMapItem:(BaseMapItem *)mapItem {
	NSDecimalNumber *sectorX = [self gridToSector:mapItem.x];
	NSDecimalNumber *sectorY = [self gridToSector:mapItem.y];
	NSString *sectorKey = [NSString stringWithFormat:@"%@x%@", sectorX, sectorY];
	NSMutableDictionary *sector = [self.sectors objectForKey:sectorKey];
	if (!sector) {
		[self loadSectorX:sectorX sectorY:sectorY];
		sector = [self.sectors objectForKey:sectorKey];
	}
	[sector setObject:mapItem forKey:[NSString stringWithFormat:@"%@x%@", mapItem.x, mapItem.y]];
}



#pragma mark -
#pragma mark Callback Methods

- (id)sectorLoaded:(LEMapGetStars *)request {
	NSString *sectorKey = [NSString stringWithFormat:@"%@x%@", [self gridToSector:request.topLeftX], [self gridToSector:request.bottomRightY]];
	NSLog(@"Sector Loaded Sector %@", sectorKey);
	
	for (NSMutableDictionary *starData in request.stars) {
		Star *star = [[Star alloc] init];
		[star parseData:starData];
		[self addMapItem:star];
		for (NSMutableDictionary *bodyData in [starData objectForKey:@"bodies"]) {
			Body *body = [[Body alloc] init];
			[body parseData:bodyData];
			[self addMapItem:body];
			[body release];
		}
		[star release];
	}
	[[self.sectors objectForKey:sectorKey] setObject:[NSDate date] forKey:@"loadedAt"];
	self.lastUpdate = [NSDate date];
	return nil;
}


@end
