//
//  LEBuildingProposeBroadcastOnNetwork19.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/9/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LERequest.h"


@interface LEBuildingProposeBroadcastOnNetwork19 : LERequest {
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSMutableDictionary *results;
@property (nonatomic, retain) NSMutableDictionary *proposition;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl message:(NSString *)message;


@end
