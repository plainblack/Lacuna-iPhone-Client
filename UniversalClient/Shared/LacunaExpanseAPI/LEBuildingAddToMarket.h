//
//  LEBuildingAddToMarket.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingAddToMarket : LERequest {
}

@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *buildingUrl;
@property(nonatomic, retain) NSDecimalNumber *askEssentia;
@property(nonatomic, retain) NSMutableArray *offer;
@property(nonatomic, retain) NSString *tradeShipId;
@property(nonatomic, retain) NSString *tradeId;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl askEssentia:(NSDecimalNumber *)askEssentia offer:(NSMutableArray *)offer tradeShipId:(NSString *)tradeShipId;


@end
