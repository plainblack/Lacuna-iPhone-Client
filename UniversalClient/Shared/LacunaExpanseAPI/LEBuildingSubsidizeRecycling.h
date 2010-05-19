//
//  LEBuildingSubsidize.h
//  UniversalClient
//
//  Created by Kevin Runde on 5/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingSubsidizeRecycling : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *buildingUrl;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl;


@end
