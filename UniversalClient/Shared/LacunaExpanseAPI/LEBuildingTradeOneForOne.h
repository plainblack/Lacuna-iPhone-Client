//
//  LEBuildingTradeOneForOne.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/21/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingTradeOneForOne : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSString *haveResourceType;
	NSString *wantResourceType;
	NSDecimalNumber *quantity;
}

@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSString *haveResourceType;
@property (nonatomic, retain) NSString *wantResourceType;
@property (nonatomic, retain) NSDecimalNumber *quantity;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl haveResourceType:(NSString *)haveResourceType wantResourceType:(NSString *)wantResourceType quantity:(NSDecimalNumber *)quantity;


@end
