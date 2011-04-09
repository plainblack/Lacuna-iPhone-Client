//
//  LEBuildingViewLaws.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/8/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingViewLaws : LERequest {
}


@property (nonatomic, retain) NSString *stationId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSMutableArray *laws;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target stationId:(NSString *)stationId buildingUrl:(NSString *)buildingUrl;


@end
