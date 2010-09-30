//
//  LEBuildingViewPlanet.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingViewPlanet : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSString *planetId;
	NSMutableDictionary *map;
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSString *planetId;
@property (nonatomic, retain) NSMutableDictionary *map;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl planetId:(NSString *)planetId;


@end
