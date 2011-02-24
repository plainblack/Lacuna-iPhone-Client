//
//  LEBuildingRecallShip.h
//  UniversalClient
//
//  Created by Kevin Runde on 2/21/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingRecallShip : LERequest {
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *buildingUrl;
@property(nonatomic, retain) NSString *shipId;
@property(nonatomic, retain) NSMutableDictionary *result;
@property(nonatomic, retain) NSMutableDictionary *shipData;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl shipId:(NSString *)shipId;


@end
