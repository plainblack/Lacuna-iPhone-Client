//
//  LEBuildingViewMyTrades.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingViewMyTrades : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSInteger pageNumber;
	NSMutableArray *myTrades;
	NSDecimalNumber *tradeCount;
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, retain) NSMutableArray *myTrades;
@property (nonatomic, retain) NSDecimalNumber *tradeCount;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl pageNumber:(NSInteger)pageNumber;


@end
