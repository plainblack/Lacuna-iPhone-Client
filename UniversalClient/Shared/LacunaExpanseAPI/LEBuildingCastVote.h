//
//  LEBuildingCastVote.h
//  UniversalClient
//
//  Created by Kevin Runde on 3/21/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingCastVote : LERequest {
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, assign) BOOL vote;
@property (nonatomic, retain) NSString *propositionId;
@property (nonatomic, retain) NSMutableArray *propositions;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl propositionId:(NSString *)propositionId vote:(BOOL)vote;


@end
