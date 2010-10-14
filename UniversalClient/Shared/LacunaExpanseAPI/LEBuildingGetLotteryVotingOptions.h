//
//  LEBuildingGetLotteryVotingOptions.h
//  UniversalClient
//
//  Created by Kevin Runde on 10/13/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingGetLotteryVotingOptions : LERequest {
	NSString *buildingId;
	NSString *buildingUrl;
	NSMutableArray *votingOptions;
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSMutableArray *votingOptions;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl;


@end
