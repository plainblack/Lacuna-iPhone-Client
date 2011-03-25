//
//  LEBuildingGetTradeableSpies.h
//  UniversalClient
//
//  Created by Kevin Runde on 3/24/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingGetTradeableSpies : LERequest {
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSMutableArray *spies;
@property (nonatomic, retain) NSDecimalNumber *cargoSpaceUsedPer;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl;


@end
