//
//  SelectPlanTypeController.h
//  UniversalClient
//
//  Created by Kevin Runde on 3/19/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@protocol SelectPlanTypeControllerDelegate

- (void)selectedPlanType:(NSMutableDictionary *)planType;

@end


@class SpaceStationLabA;


@interface SelectPlanTypeController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) SpaceStationLabA *spaceStationLab;
@property (nonatomic, retain) id<SelectPlanTypeControllerDelegate> delegate;


+ (SelectPlanTypeController *)create;


@end
