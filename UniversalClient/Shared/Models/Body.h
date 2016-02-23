//
//  Body.h
//  UniversalClient
//
//  Created by Kevin Runde on 6/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseMapItem.h"
#import "StoredResource.h"
#import "NoLimitResource.h"
#import "Building.h"


@interface Body : BaseMapItem {
}


@property (nonatomic, retain) NSString *starId;
@property (nonatomic, retain) NSString *starName;
@property (nonatomic, retain) NSDecimalNumber *orbit;
@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, retain) NSDecimalNumber *size;
@property (nonatomic, retain) NSDecimalNumber *plotsAvailable;
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
@property (nonatomic, retain) NSMutableSet *incomingForeignShips;
@property (nonatomic, assign) BOOL ignoreIncomingForeignShipData;
@property (nonatomic, assign) BOOL isPlanet;
@property (nonatomic, assign) BOOL isSpaceStation;
@property (nonatomic, retain) NSString *allianceId;
@property (nonatomic, retain) NSString *allianceName;
@property (nonatomic, retain) NSDecimalNumber *influenceTotal;
@property (nonatomic, retain) NSDecimalNumber *influenceSpent;
@property (nonatomic, retain) NSDecimalNumber *population;




- (void)parseData:(NSMutableDictionary *)bodyData;
- (void)tick:(NSInteger)interval;
- (void)loadBuildingMap;
- (void)loadBuilding:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl;
- (void)clearBuilding;


@end
