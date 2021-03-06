//
//  StarMap.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "StarMap.h"
#import "LEMacros.h"
#import "LEMapGetStar.h"
#import "LEMapGetStars.h"
#import "BaseMapItem.h"
#import "Star.h"
#import "Body.h"

#define SECTOR_SIZE [NSDecimalNumber decimalNumberWithString:@"20"]
NSTimeInterval INTERVALE_BEFORE_RELOAD = -1 * 60 * 5; //5 Minutes

@interface StarMap (PrivateMethods)

- (void)loadSectorX:(NSDecimalNumber *)sectorX sectorY:(NSDecimalNumber *)sectorY;
- (NSDecimalNumber *)gridToSector:(NSDecimalNumber *)gridValue;
- (void)addMapItem:(BaseMapItem *)mapItem gridX:(NSDecimalNumber *)gridX girdY:(NSDecimalNumber *)gridY;

@end


@implementation StarMap


@synthesize sectors;
@synthesize lastUpdate;
@synthesize numLoading;


# pragma -
#pragma mark NSObject Methods

- (id)init {
    if ((self = [super init])) {
		self.sectors = [[[NSCache alloc] init] autorelease];
		self->numLoading = 0;
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
			NSTimeInterval interval = [loadedAt timeIntervalSinceNow];
			if (interval < INTERVALE_BEFORE_RELOAD) {
				[self loadSectorX:sectorX sectorY:sectorY];
			}
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


- (void)updateStar:(NSString *)starId target:(id)inTarget callback:(SEL)inCallback {
	self->target = inTarget;
	self->callback = inCallback;
	[[[LEMapGetStar alloc] initWithCallback:@selector(starLoaded:) target:self starId:starId] autorelease];
	self.numLoading = self.numLoading + 1;
}

- (void)clearMap {
	[self.sectors removeAllObjects];
}


#pragma mark -
#pragma mark PrivateMethods

- (void)loadSectorX:(NSDecimalNumber *)sectorX sectorY:(NSDecimalNumber *)sectorY {
	NSString *sectorKey = [NSString stringWithFormat:@"%@x%@", sectorX, sectorY];
	NSDecimalNumber *topLeftX = [sectorX decimalNumberByMultiplyingBy:SECTOR_SIZE];
	NSDecimalNumber *topLeftY = [[sectorY decimalNumberByMultiplyingBy:SECTOR_SIZE] decimalNumberByAdding:SECTOR_SIZE];
	NSDecimalNumber *bottomRightX = [[sectorX decimalNumberByMultiplyingBy:SECTOR_SIZE] decimalNumberByAdding:SECTOR_SIZE];
	NSDecimalNumber *bottomRightY = [sectorY decimalNumberByMultiplyingBy:SECTOR_SIZE];
	
	[[[LEMapGetStars alloc] initWithCallback:@selector(sectorLoaded:) target:self topLeftX:topLeftX topLeftY:topLeftY bottomRightX:bottomRightX bottomRightY:bottomRightY] autorelease];
	[self.sectors setObject:[NSMutableDictionary dictionaryWithCapacity:10] forKey:sectorKey];
	self.numLoading = self.numLoading + 1;
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

- (void)sectorLoaded:(LEMapGetStars *)request {
	NSString *sectorKey = [NSString stringWithFormat:@"%@x%@", [self gridToSector:request.topLeftX], [self gridToSector:request.bottomRightY]];
	
	for (NSMutableDictionary *starData in request.stars) {
		Star *star = [[Star alloc] init];
		[star parseData:starData];
		[self addMapItem:star];
		for (NSMutableDictionary *bodyData in [starData objectForKey:@"bodies"]) {
			Body *body = [[Body alloc] init];
			body.ignoreIncomingForeignShipData = YES;
			[body parseData:bodyData];
			[self addMapItem:body];
			[body release];
		}
		[star release];
	}
	[[self.sectors objectForKey:sectorKey] setObject:[NSDate date] forKey:@"loadedAt"];
	self.lastUpdate = [NSDate date];
	self.numLoading = self.numLoading - 1;
}


- (void)starLoaded:(LEMapGetStar *)request {
	Star *star = [[Star alloc] init];
	[star parseData:request.star];
	[self addMapItem:star];
	for (NSMutableDictionary *bodyData in [request.star objectForKey:@"bodies"]) {
		Body *body = [[Body alloc] init];
		body.ignoreIncomingForeignShipData = YES;
		[body parseData:bodyData];
		[self addMapItem:body];
		[body release];
	}
	NSString *sectorKey = [NSString stringWithFormat:@"%@x%@", [self gridToSector:star.x], [self gridToSector:star.y]];
	[[self.sectors objectForKey:sectorKey] setObject:[NSDate date] forKey:@"loadedAt"];
	self.lastUpdate = [NSDate date];
	self.numLoading = self.numLoading - 1;
	[self->target performSelector:self->callback withObject:star];
	self->target = nil;
	self->callback = nil;
	[star release];
}


@end
