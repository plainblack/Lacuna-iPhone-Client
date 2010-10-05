//
//  LEStatsAllianceRank.h
//  UniversalClient
//
//  Created by Kevin Runde on 10/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEStatsAllianceRank : LERequest {
}


@property (nonatomic, retain) NSString *sortBy;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, retain) NSMutableArray *alliances;
@property (nonatomic, retain) NSDecimalNumber *numAlliances;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target sortBy:(NSString *)sortBy pageNumber:(NSInteger)pageNumber;


@end
