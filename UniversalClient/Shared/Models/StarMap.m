//
//  StarMap.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "StarMap.h"
#import "LEMapGetStars.h"
#import "Star.h"
#import "Body.h"

#define SECTOR_SIZE [NSDecimalNumber decimalNumberWithString:@"20"]


@interface StarMap (PrivateMethods)

- (void)loadSectorX:(NSDecimalNumber *)sectorX sectorY:(NSDecimalNumber *)sectorY;
- (NSDecimalNumber *)gridToSector:(NSDecimalNumber *)gridValue;

@end


@implementation StarMap


@synthesize sectors;
@synthesize lastUpdate;


# pragma -
#pragma mark NSObject Methods

- (id)init {
    if (self = [super init]) {
		self.sectors = [NSMutableDictionary dictionaryWithCapacity:5];
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

- (Star *)gridX:(NSDecimalNumber *)gridX gridY:(NSDecimalNumber *)gridY {
	NSDecimalNumber *sectorX = [self gridToSector:gridX];
	NSDecimalNumber *sectorY = [self gridToSector:gridY];
	NSString *sectorKey = [NSString stringWithFormat:@"%@x%@", sectorX, sectorY];
	NSDictionary *sector = [self.sectors objectForKey:sectorKey];
	if (sector) {
		if ((id)sector == [NSNull null]) {
			return nil;
		} else {
			NSString *gridKey = [NSString stringWithFormat:@"%@x%@", gridX, gridY];
			Star *cell = [sector objectForKey:gridKey];
			return cell;
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
	NSDecimalNumber *topLeftY = [sectorY decimalNumberByMultiplyingBy:SECTOR_SIZE];
	NSDecimalNumber *bottomRightX = [[sectorX decimalNumberByMultiplyingBy:SECTOR_SIZE] decimalNumberByAdding:SECTOR_SIZE];
	NSDecimalNumber *bottomRightY = [[sectorY decimalNumberByMultiplyingBy:SECTOR_SIZE] decimalNumberByAdding:SECTOR_SIZE];
	NSLog(@"Top Left X: %@", topLeftX);
	NSLog(@"Top Left Y: %@", topLeftY);
	NSLog(@"Bottom Right X: %@", bottomRightX);
	NSLog(@"Bottom Right Y: %@", bottomRightY);
	[[[LEMapGetStars alloc] initWithCallback:@selector(sectorLoaded:) target:self topLeftX:topLeftX topLeftY:topLeftY bottomRightX:bottomRightX bottomRightY:bottomRightY] autorelease];
	[self.sectors setObject:[NSNull null] forKey:sectorKey];
}


- (NSDecimalNumber *)gridToSector:(NSDecimalNumber *)gridValue {
	NSDecimalNumber *tmp = [gridValue decimalNumberByDividingBy:SECTOR_SIZE];
	NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:0 raiseOnExactness:FALSE raiseOnOverflow:TRUE raiseOnUnderflow:TRUE raiseOnDivideByZero:TRUE]; 
	tmp = [tmp decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
	return tmp;
}


#pragma mark -
#pragma mark Callback Methods

- (id)sectorLoaded:(LEMapGetStars *)request {
	NSString *sectorKey = [NSString stringWithFormat:@"%@x%@", [self gridToSector:request.topLeftX], [self gridToSector:request.topLeftY]];
	NSLog(@"Sector Loaded Sector %@", sectorKey);
	
	NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithCapacity:5];
	for (NSDictionary *starData in request.stars) {
		Star *star = [[[Star alloc] init] autorelease];
		[star parseData:starData];
		[tmp setObject:star forKey:[NSString stringWithFormat:@"%@x%@", star.x, star.y]];
		//KEVIN TODO: Handle bodies next
	}
	[self.sectors setObject:tmp forKey:sectorKey];
	self.lastUpdate = [NSDate date];
	return nil;
}


@end
