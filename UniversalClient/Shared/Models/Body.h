//
//  Body.h
//  UniversalClient
//
//  Created by Kevin Runde on 6/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoredResource.h"
#import "NoLimitResource.h"
#import "Building.h"


@interface Body : NSObject {
	NSString *id;
	NSDecimalNumber *x;
	NSDecimalNumber *y;
	NSString *starId;
	NSString *starName;
	NSDecimalNumber *orbit;
	NSString *type;
	NSString *name;
	NSString *imageName;
	NSDecimalNumber *size;
	NSDecimalNumber *planetWater;
	NSMutableDictionary *ores;
	NSString *empireId;
	NSString *empireName;
	NSString *alignment;
	BOOL needsSurfaceRefresh;
	NSDecimalNumber *buildingCount;
	NoLimitResource *happiness;
	StoredResource *energy;
	StoredResource *food;
	StoredResource *ore;
	StoredResource *waste;
	StoredResource *water;
	NSMutableDictionary *buildingMap;
	NSString *surfaceImageName;
	Building *currentBuilding;
	BOOL needsRefresh;
}


@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSDecimalNumber *x;
@property (nonatomic, retain) NSDecimalNumber *y;
@property (nonatomic, retain) NSString *starId;
@property (nonatomic, retain) NSString *starName;
@property (nonatomic, retain) NSDecimalNumber *orbit;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, retain) NSDecimalNumber *size;
@property (nonatomic, retain) NSDecimalNumber *planetWater;
@property (nonatomic, retain) NSMutableDictionary *ores;
@property (nonatomic, retain) NSString *empireId;
@property (nonatomic, retain) NSString *empireName;
@property (nonatomic, retain) NSString *alignment;
@property (nonatomic, assign) BOOL needsSurfaceRefresh;
@property (nonatomic, retain) NSDecimalNumber *buildingCount;
@property (nonatomic, retain) NoLimitResource *happiness;
@property (nonatomic, retain) StoredResource *energy;
@property (nonatomic, retain) StoredResource *food;
@property (nonatomic, retain) StoredResource *ore;
@property (nonatomic, retain) StoredResource *waste;
@property (nonatomic, retain) StoredResource *water;
@property (nonatomic, retain) NSMutableDictionary *buildingMap;
@property (nonatomic, retain) NSString *surfaceImageName;
@property (nonatomic, retain) Building *currentBuilding;
@property (nonatomic, assign) BOOL needsRefresh;


- (void)parseData:(NSDictionary *)bodyData;
- (void)tick:(NSInteger)interval;
- (void)loadBuildingMap;
- (void)loadBuilding:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl;
- (void)clearBuilding;


@end
