//
//  ItemPush.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ItemPush : NSObject {
}


@property (nonatomic, retain) NSString *targetId;
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) NSString *tradeShipId;
@property (nonatomic, assign) BOOL stayAtTarget;


- (void)addGlyph:(NSString *)glyphId;
- (void)addPlan:(NSString *)planId;
- (void)addPrisoner:(NSString *)prisonerId;
- (void)addResourceType:(NSString *)resourceType withQuantity:(NSDecimalNumber *)quantity;
- (void)addShip:(NSString *)shipId;


@end
