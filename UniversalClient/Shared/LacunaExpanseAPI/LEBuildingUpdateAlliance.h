//
//  LEBuildingUpdateAlliance.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingUpdateAlliance : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSString *forumUri;
	NSString *description;
	NSString *announcements;
	NSMutableDictionary *allianceStatus;
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSString *forumUri;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *announcements;
@property (nonatomic, retain) NSMutableDictionary *allianceStatus;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl forumUri:(NSString *)forumUri description:(NSString *)description announcements:(NSString *)announcements;


@end
