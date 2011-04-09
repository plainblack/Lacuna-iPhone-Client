//
//  LEBuildingProposeInductMember.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/9/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LERequest.h"


@interface LEBuildingProposeInductMember : LERequest {
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSString *empireId;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSMutableDictionary *results;
@property (nonatomic, retain) NSMutableDictionary *proposition;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl empireId:(NSString *)empireId message:(NSString *)message;


@end
