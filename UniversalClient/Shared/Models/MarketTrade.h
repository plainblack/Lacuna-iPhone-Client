//
//  MarketTrade.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MarketTrade : NSObject {
}


@property(nonatomic, retain) NSString *id;
@property(nonatomic, retain) NSDate *dateOffered;
@property(nonatomic, retain) NSDecimalNumber *askEssentia;
@property(nonatomic, retain) NSMutableArray *offerTexts;
@property(nonatomic, readonly) NSString *offerText;
@property(nonatomic, retain) NSMutableArray *offer;
@property(nonatomic, retain) NSString *bodyId;
@property(nonatomic, retain) NSString *empireId;
@property(nonatomic, retain) NSString *empireName;
@property(nonatomic, retain) NSString *tradeShipId;


- (void)parseData:(NSDictionary *)data;
- (void)addResource:(NSString *)type amount:(NSDecimalNumber *)amount;
- (void)addGlyph:(NSString *)glyphId;
- (void)addPlan:(NSString *)planId;
- (void)addPrisoner:(NSString *)prisonerId;
- (void)addSpy:(NSString *)spyId;
- (void)addShip:(NSString *)shipId;


@end
