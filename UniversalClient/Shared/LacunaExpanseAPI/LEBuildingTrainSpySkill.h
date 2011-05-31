//
//  LEBuildingTrainSpySkill.h
//  UniversalClient
//
//  Created by Kevin Runde on 5/30/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingTrainSpySkill : LERequest {
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSString *spyId;
@property (nonatomic, retain) NSMutableDictionary *results;
@property (nonatomic, retain) NSDecimalNumber *notTrained;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl spyId:(NSString *)spyId;


@end
