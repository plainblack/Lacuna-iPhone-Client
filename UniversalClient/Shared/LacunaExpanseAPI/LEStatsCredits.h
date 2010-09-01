//
//  LEStatsCredits.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEStatsCredits : LERequest {
	NSMutableArray *creditGroups;
}


@property(nonatomic, retain) NSMutableArray *creditGroups;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target;


@end
