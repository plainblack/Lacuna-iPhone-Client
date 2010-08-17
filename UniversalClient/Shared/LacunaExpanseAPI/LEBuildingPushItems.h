//
//  LEBuildingPushItems.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingPushItems : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSString *targetId;
	NSMutableArray *items;
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSString *targetId;
@property (nonatomic, retain) NSMutableArray *items;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl targetId:(NSString *)targetId items:(NSMutableArray *)items;


@end
