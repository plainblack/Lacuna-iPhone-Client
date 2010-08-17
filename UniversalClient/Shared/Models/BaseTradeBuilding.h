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


@interface BaseTradeBuilding : Building {
	NSInteger availableTradePageNumber;
	NSDecimalNumber *availableTradeCount;
	NSDate *availableTradesUpdated;
	NSMutableArray *availableTrades;
	NSInteger myTradePageNumber;
	NSDecimalNumber *myTradeCount;
	NSDate *myTradesUpdated;
	NSMutableArray *myTrades;
}


@property (nonatomic, assign) NSInteger availableTradePageNumber;
@property (nonatomic, retain) NSDecimalNumber *availableTradeCount;
@property (nonatomic, retain) NSDate *availableTradesUpdated;
@property (nonatomic, retain) NSMutableArray *availableTrades;
@property (nonatomic, assign) NSInteger myTradePageNumber;
@property (nonatomic, retain) NSDecimalNumber *myTradeCount;
@property (nonatomic, retain) NSDate *myTradesUpdated;
@property (nonatomic, retain) NSMutableArray *myTrades;


- (void)loadAvailableTradesForPage:(NSInteger)pageNumber;
- (bool)hasPreviousAvailableTradePage;
- (bool)hasNextAvailableTradePage;
- (void)loadMyTradesForPage:(NSInteger)pageNumber;
- (bool)hasPreviousMyTradePage;
- (bool)hasNextMyTradePage;
- (void)pushItems:(ItemPush *)itemPush;


@end
