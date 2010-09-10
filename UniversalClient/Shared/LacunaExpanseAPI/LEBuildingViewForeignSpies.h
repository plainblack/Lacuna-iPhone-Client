//
//  LEBuildingViewForeignSpies.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/6/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingViewForeignSpies : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSInteger pageNumber;
	NSMutableArray *foreignSpies;
	NSDecimalNumber *numberForeignSpies;
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, retain) NSMutableArray *foreignSpies;
@property (nonatomic, retain) NSDecimalNumber *numberForeignSpies;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl pageNumber:(NSInteger)pageNumber;


@end
