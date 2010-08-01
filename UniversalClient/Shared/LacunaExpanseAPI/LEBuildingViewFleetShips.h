//
//  LEBuildingViewFleetShips.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/1/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"
#import "LEMacros.h"
#import "Session.h"
#import "Ship.h"


@interface LEBuildingViewFleetShips : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSMutableArray *ships;
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSMutableArray *ships;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl;


@end
