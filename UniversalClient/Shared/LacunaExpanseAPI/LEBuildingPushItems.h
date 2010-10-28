//
//  LEBuildingPushItems.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingPushItems : LERequest {
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSString *targetId;
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) NSString *tradeShipId;
@property (nonatomic, assign) BOOL stayAtTarget;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl targetId:(NSString *)targetId items:(NSMutableArray *)items tradeShipId:(NSString *)tradeShipId stayAtTarget:(BOOL)stayAtTarget;


@end
