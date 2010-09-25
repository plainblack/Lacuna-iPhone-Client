//
//  LEStatsWeeklyMedalWinners.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEStatsWeeklyMedalWinners : LERequest {
	NSMutableArray *winners;
}


@property (nonatomic, retain) NSMutableArray *winners;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target;


@end
