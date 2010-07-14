//
//  LEBuildingViewPrisoners.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/14/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingViewPrisoners : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSInteger pageNumber;
	NSMutableArray *prisoners;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *buildingUrl;
@property(nonatomic, assign) NSInteger pageNumber;
@property(nonatomic, retain) NSMutableArray *prisoners;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl pageNumber:(NSInteger)pageNumber;


@end
