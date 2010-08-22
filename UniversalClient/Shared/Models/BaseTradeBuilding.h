//
//  BaseTradeBuilding.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@class ItemPush;
@class OneForOneTrade;


@interface BaseTradeBuilding : Building {
	NSInteger availableTradePageNumber;
	NSDecimalNumber *availableTradeCount;
	NSDate *availableTradesUpdated;
	NSMutableArray *availableTrades;
	NSInteger myTradePageNumber;
	NSDecimalNumber *myTradeCount;
	NSDate *myTradesUpdated;
	NSMutableArray *myTrades;
	NSMutableArray *glyphs;
	NSMutableDictionary *glyphsById;
	NSDecimalNumber *cargoUserPerGlyph;
	NSMutableArray *plans;
	NSMutableDictionary *plansById;
	NSDecimalNumber *cargoUserPerPlan;
	NSMutableArray *resourceTypes;
	NSMutableArray *storedResources;
	NSDecimalNumber *cargoUserPerStoredResource;
	id itemPushTarget;
	SEL itemPushCallback;
	id oneForOneTradeTarget;
	SEL oneForOneTradeCallback;
	BOOL usesEssentia;
	NSDecimalNumber *maxCargoSize;
}


@property (nonatomic, assign) NSInteger availableTradePageNumber;
@property (nonatomic, retain) NSDecimalNumber *availableTradeCount;
@property (nonatomic, retain) NSDate *availableTradesUpdated;
@property (nonatomic, retain) NSMutableArray *availableTrades;
@property (nonatomic, assign) NSInteger myTradePageNumber;
@property (nonatomic, retain) NSDecimalNumber *myTradeCount;
@property (nonatomic, retain) NSDate *myTradesUpdated;
@property (nonatomic, retain) NSMutableArray *myTrades;
@property (nonatomic, retain) NSMutableArray *glyphs;
@property (nonatomic, retain) NSMutableDictionary *glyphsById;
@property (nonatomic, retain) NSDecimalNumber *cargoUserPerGlyph;
@property (nonatomic, retain) NSMutableArray *plans;
@property (nonatomic, retain) NSMutableDictionary *plansById;
@property (nonatomic, retain) NSDecimalNumber *cargoUserPerPlan;
@property (nonatomic, retain) NSMutableArray *resourceTypes;
@property (nonatomic, retain) NSMutableArray *storedResources;
@property (nonatomic, retain) NSDecimalNumber *cargoUserPerStoredResource;
@property (nonatomic, readonly) BOOL usesEssentia;
@property (nonatomic, retain) NSDecimalNumber *maxCargoSize;



- (void)clearLoadables;
- (void)loadTradeableGlyphs;
- (void)loadTradeablePlans;
- (void)loadTradeableResourceTypes;
- (void)loadTradeableStoredResources;
- (void)removeTradeableStoredResource:(NSDictionary *)storedResource;
- (void)addTradeableStoredResource:(NSDictionary *)storedResource;
- (NSDecimalNumber *)calculateStorageForGlyphs:(NSInteger)numGlyphs plans:(NSInteger)numPlans storedResources:(NSDecimalNumber *)numStoredResources;
- (void)loadAvailableTradesForPage:(NSInteger)pageNumber;
- (bool)hasPreviousAvailableTradePage;
- (bool)hasNextAvailableTradePage;
- (void)loadMyTradesForPage:(NSInteger)pageNumber;
- (bool)hasPreviousMyTradePage;
- (bool)hasNextMyTradePage;
- (void)pushItems:(ItemPush *)itemPush target:(id)target callback:(SEL)callback;
- (void)tradeOneForOne:(OneForOneTrade *)oneForOneTrade target:(id)target callback:(SEL)callback;



@end
