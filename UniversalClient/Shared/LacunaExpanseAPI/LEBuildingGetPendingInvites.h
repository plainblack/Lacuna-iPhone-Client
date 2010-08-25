//
//  LEBuildingGetPendingInvites.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingGetPendingInvites : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSMutableArray *invites;
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSMutableArray *invites;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl;


@end
