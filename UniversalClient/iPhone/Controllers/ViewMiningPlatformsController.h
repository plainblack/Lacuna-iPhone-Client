//
//  ViewMiningPlatformsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/1/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class MiningMinistry;
@class MiningPlatform;


@interface ViewMiningPlatformsController : LETableViewControllerGrouped <UIActionSheetDelegate> {
	MiningMinistry *miningMinistry;
	MiningPlatform *selectedMiningPlatform;
}


@property (nonatomic, retain) MiningMinistry *miningMinistry;
@property (nonatomic, retain) MiningPlatform *selectedMiningPlatform;


+ (ViewMiningPlatformsController *)create;


@end
