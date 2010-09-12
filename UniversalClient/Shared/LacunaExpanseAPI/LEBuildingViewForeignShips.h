//
//  LEBuildingViewForeignShips.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/12/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingViewForeignShips : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSInteger pageNumber;
	NSMutableArray *foreignShips;
	NSDecimalNumber *numberOfShipsForeign;
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, retain) NSMutableArray *foreignShips;
@property (nonatomic, retain) NSDecimalNumber *numberOfShipsForeign;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl pageNumber:(NSInteger)pageNumber;


@end
