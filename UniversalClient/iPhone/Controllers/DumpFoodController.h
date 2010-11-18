//
//  DumpFoodController.h
//  UniversalClient
//
//  Created by Kevin Runde on 11/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "LETableViewCellNumberEntry.h"
#import "SelectResourceTypeFromListController.h"


@class FoodReserve;


@interface DumpFoodController : LETableViewControllerGrouped <SelectResourceTypeFromListControllerDelegate> {
}


@property (nonatomic, retain) FoodReserve *foodReserve;
@property (nonatomic, retain) NSString *typeToDump;
@property (nonatomic, retain) NSDecimalNumber *amountToDump;


+ (DumpFoodController *) create;


@end
