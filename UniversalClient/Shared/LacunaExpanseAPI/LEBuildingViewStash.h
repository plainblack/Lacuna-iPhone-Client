//
//  LEBuildingViewStash.h
//  UniversalClient
//
//  Created by Kevin Runde on 11/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingViewStash : LERequest {
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSMutableDictionary *stash;
@property (nonatomic, retain) NSMutableDictionary *stored;
@property (nonatomic, retain) NSDecimalNumber *maxExchangeSize;
@property (nonatomic, retain) NSDecimalNumber *exchangesRemainingToday;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl;


@end
