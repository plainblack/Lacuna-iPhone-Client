//
//  LEBuildingRunExperiment.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingRunExperiment : LERequest {
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSString *spyId;
@property (nonatomic, retain) NSString *affinity;
@property (nonatomic, assign) BOOL graftSucceeded;
@property (nonatomic, assign) BOOL spySurvived;
@property (nonatomic, retain) NSString *message;
@property(nonatomic, retain) NSMutableDictionary *result;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl spyId:(NSString *)spyId affinity:(NSString *)affinity;


@end
