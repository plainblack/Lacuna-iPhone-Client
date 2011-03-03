//
//  LEBuildingViewMarket.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingViewMarket : LERequest {
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, assign) NSInteger pageNumber;
@property(nonatomic, retain) NSString *filter;
@property (nonatomic, retain) NSMutableArray *availableTrades;
@property (nonatomic, retain) NSDecimalNumber *tradeCount;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl pageNumber:(NSInteger)pageNumber filter:(NSString *)filter;


@end
