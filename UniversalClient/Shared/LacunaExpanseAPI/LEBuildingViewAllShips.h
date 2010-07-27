//
//  LEBuildingViewAllShips.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingViewAllShips : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSArray *ships;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *buildingUrl;
@property(nonatomic, retain) NSArray *ships;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl;


@end
