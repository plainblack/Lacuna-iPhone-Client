//
//  LEBuildingAcceptFromMarket.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingAcceptFromMarket : LERequest {
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSString *tradeId;
@property (nonatomic, retain) NSString *captchaGuid;
@property (nonatomic, retain) NSString *captchaSolution;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl tradeId:(NSString *)tradeId captchaGuid:(NSString *)captchaGuid captchaSolution:(NSString *)captchaSolution;


@end
