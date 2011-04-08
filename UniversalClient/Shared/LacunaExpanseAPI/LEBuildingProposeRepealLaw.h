//
//  LEBuildingProposeRepealLaw.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/8/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingProposeRepealLaw : LERequest {
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSString *lawId;
@property (nonatomic, retain) NSMutableDictionary *proposition;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl lawId:(NSString *)lawId;


@end
