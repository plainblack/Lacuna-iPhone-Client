//
//  ViewMiningFleetShips.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/1/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class MiningMinistry;


@interface ViewMiningFleetShipsController : LETableViewControllerGrouped {
	MiningMinistry *miningMinistry;
}


@property (nonatomic, retain) MiningMinistry *miningMinistry;


+ (ViewMiningFleetShipsController *)create;


@end
