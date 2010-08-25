//
//  LEBuildingSendInvite.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingSendInvite : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSString *inviteeId;
	NSString *message;
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSString *inviteeId;
@property (nonatomic, retain) NSString *message;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl inviteeId:(NSString *)inviteeId message:(NSString *)message;


@end
