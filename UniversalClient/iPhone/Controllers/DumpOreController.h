//
//  DumpOreController.h
//  UniversalClient
//
//  Created by Kevin Runde on 11/16/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "LETableViewCellNumberEntry.h"
#import "SelectResourceTypeFromListController.h"


@class OreStorage;


@interface DumpOreController : LETableViewControllerGrouped <SelectResourceTypeFromListControllerDelegate> {
}


@property (nonatomic, retain) OreStorage *oreStorage;
@property (nonatomic, retain) NSString *typeToDump;
@property (nonatomic, retain) NSDecimalNumber *amountToDump;


+ (DumpOreController *) create;


@end
