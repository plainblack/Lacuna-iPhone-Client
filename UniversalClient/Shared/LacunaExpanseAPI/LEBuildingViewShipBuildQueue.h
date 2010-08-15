//
//  LEBuildingViewShipBuildQueue.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingViewShipBuildQueue : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSMutableArray *shipBuildQueue;
	NSDecimalNumber *numberShipBuilding;
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSMutableArray *shipBuildQueue;
@property (nonatomic, retain) NSDecimalNumber *numberShipBuilding;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl;


@end
