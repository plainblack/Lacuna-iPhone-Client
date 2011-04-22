//
//  LEBuildingBuildShip.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingBuildShip : LERequest {
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSString *shipType;
@property (nonatomic, retain) NSMutableDictionary *result;
@property (nonatomic, retain) NSMutableDictionary *workData;
@property (nonatomic, retain) NSDecimalNumber *numberShipBuilding;
@property (nonatomic, retain) NSDecimalNumber *subsidizeBuildCost;
@property (nonatomic, retain) NSMutableArray *shipBuildQueue;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl shipType:(NSString *)shipType;


@end
