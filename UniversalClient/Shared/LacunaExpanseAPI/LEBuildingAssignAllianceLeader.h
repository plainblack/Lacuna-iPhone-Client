//
//  LEBuildingAssignAllianceLeader.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingAssignAllianceLeader : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSString *newLeaderId;
	NSMutableDictionary *allianceStatus;
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSString *newLeaderId;
@property (nonatomic, retain) NSMutableDictionary *allianceStatus;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl newLeaderId:(NSString *)newLeaderId;


@end
