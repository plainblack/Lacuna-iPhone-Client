//
//  ItemPush.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ItemPush : NSObject {
	NSString *targetId;
	NSMutableArray *items;
}


@property (nonatomic, assign) NSString *targetId;
@property (nonatomic, assign) NSMutableArray *items;


- (void)addResourceType:(NSString *)resourceType withQuantity:(NSDecimalNumber *)quantity;
- (void)addGlyph:(NSString *)glyphId;
- (void)addPlan:(NSString *)planId;


@end
