//
//  LEBuildingRecycle.h
//  UniversalClient
//
//  Created by Kevin Runde on 5/13/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingRecycle : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSDecimalNumber *energy;
	NSDecimalNumber *ore;
	NSDecimalNumber *water;
	BOOL subsidized;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *buildingUrl;
@property(nonatomic, retain) NSDecimalNumber *energy;
@property(nonatomic, retain) NSDecimalNumber *ore;
@property(nonatomic, retain) NSDecimalNumber *water;
@property(nonatomic) BOOL subsidized;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl energy:(NSDecimalNumber *)energy ore:(NSDecimalNumber *)ore water:(NSDecimalNumber *)water subsidized:(BOOL)subsidized;


@end
