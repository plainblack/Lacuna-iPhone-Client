//
//  LEBuildingTransmitFood.h
//  UniversalClient
//
//  Created by Kevin Runde on 11/21/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingTransmitFood : LERequest {
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSMutableDictionary *result;
@property (nonatomic, retain) NSMutableDictionary *buildingData;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl;


@end
