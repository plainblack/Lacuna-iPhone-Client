//
//  LEBuildingGetOresAvailableForProcessing.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/22/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingGetOresAvailableForProcessing : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSMutableArray *oreTypes;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *buildingUrl;
@property(nonatomic, retain) NSMutableArray *oreTypes;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl;


@end
