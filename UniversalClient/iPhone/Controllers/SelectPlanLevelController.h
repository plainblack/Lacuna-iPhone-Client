//
//  SelectPlanLevelController.h
//  UniversalClient
//
//  Created by Kevin Runde on 3/19/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@protocol SelectPlanLevelControllerDelegate

- (void)selectedPlanLevel:(NSMutableDictionary *)planLevel;

@end


@class SpaceStationLabA;


@interface SelectPlanLevelController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) SpaceStationLabA *spaceStationLab;
@property (nonatomic, retain) id<SelectPlanLevelControllerDelegate> delegate;


+ (SelectPlanLevelController *)create;


@end
