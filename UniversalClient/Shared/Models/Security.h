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
	NSInteger prisonersPageNumber;
	NSInteger foreignSpyPageNumber;
	NSDecimalNumber *numPrisoners;
	NSDecimalNumber *numForeignSpy;
}


@property (nonatomic, retain) NSMutableArray *prisoners;
@property (nonatomic, retain) NSDate *prisonersUpdated;
@property (nonatomic, retain) NSMutableArray *foreignSpies;
@property (nonatomic, retain) NSDate *foreignSpiesUpdated;
@property (nonatomic, assign) NSInteger prisonersPageNumber;
@property (nonatomic, assign) NSInteger foreignSpyPageNumber;
@property (nonatomic, retain) NSDecimalNumber *numPrisoners;
@property (nonatomic, retain) NSDecimalNumber *numForeignSpy;


- (void)loadPrisonersForPage:(NSInteger)pageNumber;
- (void)loadForeignSpiesForPage:(NSInteger)pageNumber;
- (void)executePrisoner:(NSString *)prisonerId;
- (void)releasePrisoner:(NSString *)prisonerId;
- (bool)hasPreviousPrisonersPage;
- (bool)hasNextPrisonersPage;
- (bool)hasPreviousForeignSpyPage;
- (bool)hasNextForeignSpyPage;


@end
