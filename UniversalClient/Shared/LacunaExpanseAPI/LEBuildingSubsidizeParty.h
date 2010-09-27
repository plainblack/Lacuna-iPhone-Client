//
//  LEBuildingSubsidizeParty.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingSubsidizeParty : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSMutableDictionary *result;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *buildingUrl;
@property(nonatomic, retain) NSMutableDictionary *result;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl;


@end
