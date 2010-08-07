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
	NSMutableArray *foreignSpies;
	NSDate *foreignSpiesUpdated;
}


@property (nonatomic, retain) NSMutableArray *prisoners;
@property (nonatomic, retain) NSDate *prisonersUpdated;
@property (nonatomic, retain) NSMutableArray *foreignSpies;
@property (nonatomic, retain) NSDate *foreignSpiesUpdated;


- (void)loadPrisoners;
- (void)loadForeignSpies;
- (void)executePrisoner:(NSString *)prisonerId;
- (void)releasePrisoner:(NSString *)prisonerId;


@end
