//
//  LEBuildingExpelMember.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingExpelMember : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSString *empireId;
	NSString *message;
	NSMutableDictionary *allianceStatus;
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSString *empireId;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSMutableDictionary *allianceStatus;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl empireId:(NSString *)empireId message:(NSString *)message;


@end
