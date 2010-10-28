//
//  LEBuildingAddTrade.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/22/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingAddTrade : LERequest {
}

@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSString *askType;
@property (nonatomic, retain) NSDecimalNumber *askQuantity;
@property (nonatomic, retain) NSString *offerType;
@property (nonatomic, retain) NSDecimalNumber *offerQuantity;
@property (nonatomic, retain) NSString *offerGlyphId;
@property (nonatomic, retain) NSString *offerPlanId;
@property (nonatomic, retain) NSString *offerPrisonerId;
@property (nonatomic, retain) NSString *offerShipId;
@property (nonatomic, retain) NSString *tradeId;
@property (nonatomic, retain) NSString *tradeShipId;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl askType:(NSString *)askType askQuantity:(NSDecimalNumber *)askQuantity offerType:(NSString *)offerType offerQuantity:(NSDecimalNumber *)offerQuantity offerGlyphId:(NSString *)offerGlyphId offerPlanId:(NSString *)offerPlanId offerPrisonerId:(NSString *)offerPrisonerId offerShipId:(NSString *)offerShipId tradeShipId:(NSString *)tradeShipId;


@end
