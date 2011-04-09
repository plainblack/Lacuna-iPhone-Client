//
//  LEBuildingGetBodiesForStarInJurisdiction.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/9/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingGetBodiesForStarInJurisdiction : LERequest {
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSString *starId;
@property (nonatomic, retain) NSMutableDictionary *results;
@property (nonatomic, retain) NSMutableArray *bodies;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl starId:(NSString *)starId;


@end
