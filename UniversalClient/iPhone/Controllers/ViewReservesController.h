//
//  ViewReservesController.h
//  UniversalClient
//
//  Created by Kevin Runde on 3/17/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class DistributionCenter;


@interface ViewReservesController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) DistributionCenter *distributionCenter;


+ (ViewReservesController *)create;


@end
