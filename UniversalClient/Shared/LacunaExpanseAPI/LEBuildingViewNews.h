//
//  LEBuildingViewNews.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingViewNews : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSArray *newsItems;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *buildingUrl;
@property(nonatomic, retain) NSArray *newsItems;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl;


@end
