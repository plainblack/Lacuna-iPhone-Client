//
//  LEBuildingWithdrawInvite.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingWithdrawInvite : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSString *inviteId;
	NSString *message;
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSString *inviteId;
@property (nonatomic, retain) NSString *message;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl inviteId:(NSString *)inviteId message:(NSString *)message;


@end
