//
//  DumpEnergyController.h
//  UniversalClient
//
//  Created by Kevin Runde on 11/16/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "LETableViewCellNumberEntry.h"


@class EnergyReserve;


@interface DumpEnergyController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) EnergyReserve *energyReserve;
@property (nonatomic, retain) LETableViewCellNumberEntry *amountCell;


+ (DumpEnergyController *) create;


@end
