//
//  DumpWaterController.h
//  UniversalClient
//
//  Created by Kevin Runde on 11/16/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "LETableViewCellNumberEntry.h"


@class WaterStorage;


@interface DumpWaterController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) WaterStorage *waterStorage;
@property (nonatomic, retain) LETableViewCellNumberEntry *amountCell;


+ (DumpWaterController *) create;


@end
