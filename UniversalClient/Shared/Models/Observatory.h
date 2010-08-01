//
//  Observatory.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@interface Observatory : Building {
	NSMutableArray *probedStars;
}


@property (nonatomic, retain) NSMutableArray *probedStars;


- (void)loadProbedStars;
- (void)abandonProbeAtStar:(NSString *)starId;


@end
