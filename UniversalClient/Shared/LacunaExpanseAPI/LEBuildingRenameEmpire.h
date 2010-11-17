//
//  LEBuildingRenameEmpire.h
//  UniversalClient
//
//  Created by Kevin Runde on 11/16/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingRenameEmpire : LERequest {
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *buildingUrl;
@property(nonatomic, retain) NSString *newEmpireName;
@property(nonatomic, retain) NSString *oldEmpireName;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl newEmpireName:(NSString *)newEmpireName;


@end
