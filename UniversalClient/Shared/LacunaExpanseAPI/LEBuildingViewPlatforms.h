//
//  LEBuildingViewPlatforms.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/1/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingViewPlatforms : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSMutableArray *platforms;
	NSInteger maxPlatforms;
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSMutableArray *platforms;
@property (nonatomic, assign) NSInteger maxPlatforms;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl;


@end
