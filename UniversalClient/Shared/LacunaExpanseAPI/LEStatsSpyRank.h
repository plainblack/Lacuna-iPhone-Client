//
//  LEStatsSpyRank.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEStatsSpyRank : LERequest {
	NSString *sortBy;
	NSMutableArray *spies;
}


@property (nonatomic, retain) NSString *sortBy;
@property (nonatomic, retain) NSMutableArray *spies;

- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target sortBy:(NSString *)sortBy;


@end
