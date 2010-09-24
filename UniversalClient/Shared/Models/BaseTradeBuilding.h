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
@class Trade;


@interface BaseTradeBuilding : Building {
	NSInteger availableTradePageNumber;
	NSDecimalNumber *availableTradeCount;
	NSDate *availableTradesUpdated;
	NSMutableArray *availableTrades;
	NSString *captchaGuid;
	NSString *captchaUrl;
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
	NSMutableArray *prisoners;
	NSMutableDictionary *prisonersById;
	NSDecimalNumber *cargoUserPerPrisoner;
	NSMutableArray *resourceTypes;
	NSMutableArray *ships;
	NSMutableDictionary *shipsById;
	NSDecimalNumber *cargoUserPerShip;
	NSMutableArray *storedResources;
	NSDecimalNumber *cargoUserPerStoredResource;
	id itemPushTarget;
	SEL itemPushCallback;
	id oneForOneTradeTarget;
	SEL oneForOneTradeCallback;
	id postTradeTarget;
	SEL postTradeCallback;
	id acceptTradeTarget;
	SEL acceptTradeCallback;
	BOOL usesEssentia;
	NSDecimalNumber *maxCargoSize;
}


@property (nonatomic, assign) NSInteger availableTradePageNumber;
@property (nonatomic, retain) NSDecimalNumber *availableTradeCount;
@property (nonatomic, retain) NSDate *availableTradesUpdated;
@property (nonatomic, retain) NSMutableArray *availableTrades;
@property (nonatomic, retain) NSString *captchaGuid;
@property (nonatomic, retain) NSString *captchaUrl;
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
@property (nonatomic, retain) NSMutableArray *prisoners;
@property (nonatomic, retain) NSMutableDictionary *prisonersById;
@property (nonatomic, retain) NSDecimalNumber *cargoUserPerPrisoner;
@property (nonatomic, retain) NSMutableArray *ships;
@property (nonatomic, retain) NSMutableDictionary *shipsById;
@property (nonatomic, retain) NSDecimalNumber *cargoUserPerShip;
@property (nonatomic, retain) NSMutableArray *resourceTypes;
@property (nonatomic, retain) NSMutableArray *storedResources;
@property (nonatomic, retain) NSDecimalNumber *cargoUserPerStoredResource;
@property (nonatomic, readonly) BOOL usesEssentia;
@property (nonatomic, retain) NSDecimalNumber *maxCargoSize;



- (void)clearLoadables;
- (void)loadTradeableGlyphs;
- (void)loadTradeablePlans;
- (void)loadTradeablePrisoners;
- (void)loadTradeableResourceTypes;
- (void)loadTradeableShips;
- (void)loadTradeableStoredResources;
- (void)removeTradeableStoredResource:(NSDictionary *)storedResource;
- (void)addTradeableStoredResource:(NSDictionary *)storedResource;
- (NSDecimalNumber *)calculateStorageForGlyphs:(NSInteger)numGlyphs plans:(NSInteger)numPlans prisoners:(NSInteger)numPrisoners storedResources:(NSDecimalNumber *)numStoredResources ships:(NSInteger)numShips;
- (void)loadAvailableTradesForPage:(NSInteger)pageNumber;
- (bool)hasPreviousAvailableTradePage;
- (bool)hasNextAvailableTradePage;
- (void)loadMyTradesForPage:(NSInteger)pageNumber;
- (bool)hasPreviousMyTradePage;
- (bool)hasNextMyTradePage;
- (void)pushItems:(ItemPush *)itemPush target:(id)target callback:(SEL)callback;
- (void)tradeOneForOne:(OneForOneTrade *)oneForOneTrade target:(id)target callback:(SEL)callback;
- (void)postTrade:(Trade *)trade target:(id)target callback:(SEL)callback;
- (void)acceptTrade:(Trade *)trade solution:(NSString *)solution target:(id)target callback:(SEL)callback;
- (void)withdrawTrade:(Trade *)trade;



@end
