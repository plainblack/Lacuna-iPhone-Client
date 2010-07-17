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
	WasteRecycling *wasteRecycling;
	NSInteger secondsPerResource;
	NSInteger seconds;
	LETableViewCellNumberEntry *energyCell;
	LETableViewCellNumberEntry *oreCell;
	LETableViewCellNumberEntry *waterCell;
	LETableViewCellLabeledSwitch *subsidizedCell;
}


@property(nonatomic, retain) WasteRecycling *wasteRecycling;
@property(nonatomic, assign) NSInteger secondsPerResource;
@property(nonatomic, assign) NSInteger seconds;
@property(nonatomic, retain) LETableViewCellNumberEntry *energyCell;
@property(nonatomic, retain) LETableViewCellNumberEntry *oreCell;
@property(nonatomic, retain) LETableViewCellNumberEntry *waterCell;
@property(nonatomic, retain) LETableViewCellLabeledSwitch *subsidizedCell;


+ (RecycleController *) create;


@end
