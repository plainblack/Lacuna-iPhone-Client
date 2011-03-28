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
@class MarketTrade;


@interface BaseTradeBuilding : Building {
	id itemPushTarget;
	SEL itemPushCallback;
	id oneForOneTradeTarget;
	SEL oneForOneTradeCallback;
	id postToMarketTarget;
	SEL postToMarketCallback;
	id acceptFromMarketTarget;
	SEL acceptFromMarketCallback;
}


@property (nonatomic, assign) NSInteger marketPageNumber;
@property (nonatomic, assign) NSString *marketFilter;
@property (nonatomic, retain) NSDecimalNumber *marketTradeCount;
@property (nonatomic, retain) NSDate *marketUpdated;
@property (nonatomic, retain) NSMutableArray *marketTrades;
@property (nonatomic, assign) NSInteger myMarketPageNumber;
@property (nonatomic, retain) NSDecimalNumber *myMarketTradeCount;
@property (nonatomic, retain) NSDate *myMarketUpdated;
@property (nonatomic, retain) NSMutableArray *myMarketTrades;

@property (nonatomic, retain) NSMutableArray *glyphs;
@property (nonatomic, retain) NSMutableDictionary *glyphsById;
@property (nonatomic, retain) NSDecimalNumber *cargoUsedPerGlyph;
@property (nonatomic, retain) NSMutableArray *plans;
@property (nonatomic, retain) NSMutableDictionary *plansById;
@property (nonatomic, retain) NSDecimalNumber *cargoUsedPerPlan;
@property (nonatomic, retain) NSMutableArray *prisoners;
@property (nonatomic, retain) NSMutableDictionary *prisonersById;
@property (nonatomic, retain) NSDecimalNumber *cargoUsedPerPrisoner;
@property (nonatomic, retain) NSMutableArray *spies;
@property (nonatomic, retain) NSMutableDictionary *spiesById;
@property (nonatomic, retain) NSDecimalNumber *cargoUsedPerSpy;
@property (nonatomic, retain) NSMutableArray *ships;
@property (nonatomic, retain) NSMutableDictionary *shipsById;
@property (nonatomic, retain) NSDecimalNumber *cargoUsedPerShip;
@property (nonatomic, retain) NSMutableArray *resourceTypes;
@property (nonatomic, retain) NSMutableArray *storedResources;
@property (nonatomic, retain) NSDecimalNumber *cargoUsedPerStoredResource;
@property (nonatomic, assign) BOOL usesEssentia;
@property (nonatomic, assign) BOOL selectTradeShip;
@property (nonatomic, retain) NSDecimalNumber *maxCargoSize;
@property (nonatomic, retain) NSMutableArray *tradeShips;
@property (nonatomic, retain) NSMutableDictionary *tradeShipsById;
@property (nonatomic, retain) NSMutableDictionary *tradeShipsTravelTime;


- (void)clearLoadables;
- (void)loadTradeableGlyphs;
- (void)loadTradeablePlans;
- (void)loadTradeablePrisoners;
- (void)loadTradeableSpies;
- (void)loadTradeableResourceTypes;
- (void)loadTradeableShips;
- (void)loadTradeableStoredResources;
- (void)loadTradeShipsToBody:(NSString *)targetBodyId;
- (void)removeTradeableStoredResource:(NSDictionary *)storedResource;
- (void)addTradeableStoredResource:(NSDictionary *)storedResource;
- (NSDecimalNumber *)calculateStorageForGlyphs:(NSInteger)numGlyphs plans:(NSInteger)numPlans prisoners:(NSInteger)numPrisoners spies:(NSInteger)numSpies storedResources:(NSDecimalNumber *)numStoredResources ships:(NSInteger)numShips;
- (void)pushItems:(ItemPush *)itemPush target:(id)target callback:(SEL)callback;
- (void)tradeOneForOne:(OneForOneTrade *)oneForOneTrade target:(id)target callback:(SEL)callback;
- (void)loadMarketPage:(NSInteger)pageNumber filter:(NSString *)filter;
- (bool)hasPreviousMarketPage;
- (bool)hasNextMarketPage;
- (void)loadMyMarketPage:(NSInteger)pageNumber;
- (bool)hasPreviousMyMarketPage;
- (bool)hasNextMyMarketPage;
- (void)postMarketTrade:(MarketTrade *)trade target:(id)target callback:(SEL)callback;
- (void)acceptMarketTrade:(MarketTrade *)trade target:(id)target callback:(SEL)callback;
- (void)withdrawMarketTrade:(MarketTrade *)trade;



@end
