//
//  LEBuildingGetBuildableShips.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingGetBuildableShips : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSMutableArray *buildableShips;
	NSDecimalNumber *docksAvailable;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *buildingUrl;
@property(nonatomic, retain) NSMutableArray *buildableShips;
@property(nonatomic, retain) NSDecimalNumber *docksAvailable;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl;


@end
