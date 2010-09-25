//
//  LEStatsEmpireRank.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEStatsEmpireRank : LERequest {
	NSString *sortBy;
	NSInteger pageNumber;
	NSMutableArray *empires;
	NSDecimalNumber *numEmpires;
}


@property (nonatomic, retain) NSString *sortBy;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, retain) NSMutableArray *empires;
@property (nonatomic, retain) NSDecimalNumber *numEmpires;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target sortBy:(NSString *)sortBy pageNumber:(NSInteger)pageNumber;


@end
