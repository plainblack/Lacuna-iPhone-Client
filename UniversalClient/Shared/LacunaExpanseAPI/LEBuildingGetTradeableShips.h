//
//  LEBuildingGetTradeableShips.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingGetTradeableShips : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSMutableArray *ships;
	NSDecimalNumber *cargoSpaceUsedPer;
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSMutableArray *ships;
@property (nonatomic, retain) NSDecimalNumber *cargoSpaceUsedPer;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl;


@end
