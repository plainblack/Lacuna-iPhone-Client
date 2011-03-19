//
//  MakePlanViewController.h
//  UniversalClient
//
//  Created by Kevin Runde on 3/19/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "SelectPlanTypeController.h"
#import "SelectPlanLevelController.h"


@class SpaceStationLabA;


@interface MakePlanViewController : LETableViewControllerGrouped <SelectPlanTypeControllerDelegate, SelectPlanLevelControllerDelegate> {
}


@property (nonatomic, retain) SpaceStationLabA *spaceStationLab;
@property (nonatomic, retain) NSMutableDictionary *planType;
@property (nonatomic, retain) NSMutableDictionary *planLevel;


+ (MakePlanViewController *)create;


@end
