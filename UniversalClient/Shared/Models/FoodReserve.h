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
	NSMutableDictionary *storedFood;
}


@property (nonatomic, retain) NSMutableDictionary *storedFood;


@end
