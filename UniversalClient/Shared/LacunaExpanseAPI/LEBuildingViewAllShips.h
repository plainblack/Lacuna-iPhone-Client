//
//  LEBuildingViewAllShips.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingViewAllShips : LERequest {
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *buildingUrl;
@property(nonatomic, retain) NSString *tag;
@property(nonatomic, retain) NSString *task;
@property(nonatomic, retain) NSMutableArray *ships;
@property (nonatomic, retain) NSDecimalNumber *numberOfShips;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl tag:(NSString *)tag task:(NSString *)task;


@end
