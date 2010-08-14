//
//  LEBuildingTrainSpy.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingTrainSpy : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSDecimalNumber *quantity;
	NSDecimalNumber *trained;
	NSDecimalNumber *notTrained;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *buildingUrl;
@property(nonatomic, retain) NSDecimalNumber *quantity;
@property(nonatomic, retain) NSDecimalNumber *trained;
@property(nonatomic, retain) NSDecimalNumber *notTrained;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl quantity:(NSDecimalNumber *)quantity;


@end
