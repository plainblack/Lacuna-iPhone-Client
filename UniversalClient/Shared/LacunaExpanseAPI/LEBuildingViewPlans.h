//
//  LEBuildingViewPlans.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/12/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingViewPlans : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSMutableArray *plans;
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSMutableArray *plans;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl;


@end
