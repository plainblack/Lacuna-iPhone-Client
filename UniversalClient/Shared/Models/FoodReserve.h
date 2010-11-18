//
//  FoodReserve.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@interface FoodReserve : Building {
	id dumpFoodTarget;
	SEL dumpFoodCallback;
}


@property (nonatomic, retain) NSMutableDictionary *storedFood;


- (void)dumpFood:(NSDecimalNumber *)amount type:(NSString *)type target:(id)dumpFoodTarget callback:(SEL)dumpFoodCallback;


@end
