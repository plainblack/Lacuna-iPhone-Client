//
//  SpySecurity.h
//  UniversalClient
//
//  Created by Kevin Runde on 5/8/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SpySecurity <NSObject>


@property (nonatomic, retain) NSMutableArray *prisoners;
@property (nonatomic, retain) NSDate *prisonersUpdated;
@property (nonatomic, assign) NSInteger prisonersPageNumber;
@property (nonatomic, retain) NSDecimalNumber *numPrisoners;
@property (nonatomic, retain) NSMutableArray *foreignSpies;
@property (nonatomic, retain) NSDate *foreignSpiesUpdated;
@property (nonatomic, assign) NSInteger foreignSpyPageNumber;
@property (nonatomic, retain) NSDecimalNumber *numForeignSpy;


- (void)loadPrisonersForPage:(NSInteger)pageNumber;
- (void)executePrisoner:(NSString *)prisonerId;
- (void)releasePrisoner:(NSString *)prisonerId;
- (bool)hasPreviousPrisonersPage;
- (bool)hasNextPrisonersPage;
- (void)loadForeignSpiesForPage:(NSInteger)pageNumber;
- (bool)hasPreviousForeignSpyPage;
- (bool)hasNextForeignSpyPage;


@end
