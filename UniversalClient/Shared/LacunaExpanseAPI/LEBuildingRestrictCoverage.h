//
//  LEBuildingRestrictCoverage.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingRestrictCoverage : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	BOOL isRestricted;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *buildingUrl;
@property(nonatomic) BOOL isRestricted;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl restricted:(BOOL)restricted;


@end
