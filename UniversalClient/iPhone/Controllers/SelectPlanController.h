//
//  SelectPlanController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class BaseTradeBuilding;
@class Plan;


@protocol SelectPlanControllerDelegate

- (void)planSelected:(Plan *)plan;

@end


@interface SelectPlanController : LETableViewControllerGrouped {
	BaseTradeBuilding *baseTradeBuilding;
	id<SelectPlanControllerDelegate> delegate;
}


@property (nonatomic, retain) BaseTradeBuilding *baseTradeBuilding;
@property (nonatomic, assign) id<SelectPlanControllerDelegate> delegate;


+ (SelectPlanController *) create;


@end
