//
//  RecycleController.h
//  UniversalClient
//
//  Created by Kevin Runde on 5/13/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class LETableViewCellNumberEntry;
@class LETableViewCellLabeledSwitch;
@class WasteRecycling;


@interface RecycleController : LETableViewControllerGrouped {
}


@property(nonatomic, retain) WasteRecycling *wasteRecycling;
@property(nonatomic, retain) NSDecimalNumber *secondsPerResource;
@property(nonatomic, retain) NSDecimalNumber *seconds;
@property(nonatomic, retain) LETableViewCellNumberEntry *energyCell;
@property(nonatomic, retain) LETableViewCellNumberEntry *oreCell;
@property(nonatomic, retain) LETableViewCellNumberEntry *waterCell;
@property(nonatomic, retain) LETableViewCellLabeledSwitch *subsidizedCell;


- (NSDecimalNumber *)remainingStored;
- (NSDecimalNumber *)remainingMax;


+ (RecycleController *) create;


@end
