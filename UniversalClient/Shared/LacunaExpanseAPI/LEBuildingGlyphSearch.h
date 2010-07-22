//
//  LEBuildingGlyphSearch.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingGlyphSearch : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSString *oreType;
	NSInteger secondsRemaining;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *buildingUrl;
@property(nonatomic, retain) NSString *oreType;
@property(nonatomic, assign) NSInteger secondsRemaining;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl oreType:(NSString *)oreType;


@end
