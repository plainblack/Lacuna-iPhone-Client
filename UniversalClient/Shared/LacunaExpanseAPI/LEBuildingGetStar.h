//
//  LEBuildingGetStar.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/23/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingGetStar : LERequest {
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSString *starId;
@property (nonatomic, retain) NSMutableDictionary *star;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl starId:(NSString *)starId;


@end
