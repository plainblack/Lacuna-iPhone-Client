//
//  StarMap.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "StarMap.h"

#define SECTOR_SIZE [NSDecimalNumber decimalNumberWithString:@"20"]


@interface StarMap (PrivateMethods)

- (void)loadSector:(NSString *)sectorKey;
- (NSDecimalNumber *)gridToSector:(NSDecimalNumber *)gridValue;

@end


@implementation StarMap


@synthesize sectors;


# pragma -
#pragma mark NSObject Methods

- (void)dealloc {
	self.sectors = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (NSDictionary *)gridX:(NSDecimalNumber *)gridX gridY:(NSDecimalNumber *)gridY {
	NSDecimalNumber *sectorX = [self gridToSector:gridX];
	NSDecimalNumber *sectorY = [self gridToSector:gridY];
	NSString *sectorKey = [NSString stringWithFormat:@"%@x%@", sectorX, sectorY];
	NSDictionary *sector = [self.sectors objectForKey:sectorKey];
	if (sector) {
		if ((id)sector == [NSNull null]) {
			NSLog(@"Sector is loading");
			return nil;
		} else {
			NSString *gridKey = [NSString stringWithFormat:@"%@x%@", gridX, sectorY];
			NSDictionary *cell = [sector objectForKey:gridKey];
			return cell;
		}
	} else {
		[self loadSector:sectorKey];
		return nil;
	}

}


#pragma mark -
#pragma mark PrivateMethods

- (void)loadSector:(NSString *)sectorKey {
	NSLog(@"Loading %@", sectorKey);
	[self.sectors setObject:[NSNull null] forKey:sectorKey];
}


- (NSDecimalNumber *)gridToSector:(NSDecimalNumber *)gridValue {
	NSDecimalNumber *tmp = [gridValue decimalNumberByDividingBy:SECTOR_SIZE];
	tmp = [tmp decimalNumberByRoundingAccordingToBehavior:NSRoundPlain];
	NSLog(@"Grid:%@, Sector:%@", gridValue, tmp);

	return tmp;
}


@end
