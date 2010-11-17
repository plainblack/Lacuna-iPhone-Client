//
//  LEBuildingNameShip.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingNameShip : LERequest {
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *buildingUrl;
@property(nonatomic, retain) NSString *shipId;
@property(nonatomic, retain) NSString *name;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl shipId:(NSString *)shipId name:(NSString *)name;


@end
