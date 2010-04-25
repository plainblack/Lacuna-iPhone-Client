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
	NSNumber *quantity;
	NSNumber *trained;
	NSNumber *notTrained;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *buildingUrl;
@property(nonatomic, retain) NSNumber *quantity;
@property(nonatomic, retain) NSNumber *trained;
@property(nonatomic, retain) NSNumber *notTrained;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl quantity:(NSNumber *)quantity;


@end
