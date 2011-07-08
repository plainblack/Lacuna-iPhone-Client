//
//  LEBuildingViewBattleReport.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/7/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingViewBattleReport : LERequest {
}


@property (nonatomic, retain) NSString *buildingId;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, retain) NSMutableArray *battleLogs;
@property (nonatomic, retain) NSDecimalNumber *numberOfBattleLogs;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl pageNumber:(NSInteger)pageNumber;

@end

