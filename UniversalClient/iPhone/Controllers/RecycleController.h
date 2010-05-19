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


@interface RecycleController : LETableViewControllerGrouped {
	NSString *buildingId;
	NSString *urlPart;
	NSNumber *secondsPerResource;
	LETableViewCellNumberEntry *energyCell;
	LETableViewCellNumberEntry *oreCell;
	LETableViewCellNumberEntry *waterCell;
	LETableViewCellLabeledSwitch *subsidizedCell;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *urlPart;
@property(nonatomic, retain) NSNumber *secondsPerResource;
@property(nonatomic, retain) LETableViewCellNumberEntry *energyCell;
@property(nonatomic, retain) LETableViewCellNumberEntry *oreCell;
@property(nonatomic, retain) LETableViewCellNumberEntry *waterCell;
@property(nonatomic, retain) LETableViewCellLabeledSwitch *subsidizedCell;


+ (RecycleController *) create;


@end
