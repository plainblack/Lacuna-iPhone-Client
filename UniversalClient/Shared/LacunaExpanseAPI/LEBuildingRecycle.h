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
	NSNumber *energy;
	NSNumber *ore;
	NSNumber *water;
	BOOL subsidized;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *buildingUrl;
@property(nonatomic, retain) NSNumber *energy;
@property(nonatomic, retain) NSNumber *ore;
@property(nonatomic, retain) NSNumber *water;
@property(nonatomic) BOOL subsidized;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl energy:(NSNumber *)energy ore:(NSNumber *)ore water:(NSNumber *)water subsidized:(BOOL)subsidized;


@end
