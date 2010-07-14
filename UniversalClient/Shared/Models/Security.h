//
//  Security.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/14/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@interface Security : Building {
	NSMutableArray *prisoners;
	NSDate *prisonersUpdated;
}


@property (nonatomic, retain) NSMutableArray *prisoners;
@property (nonatomic, retain) NSDate *prisonersUpdated;


- (void)loadPrisoners;


@end
