//
//  ViewUpgradableBuildingsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 11/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class HallsOfVrbansk;


@interface ViewUpgradableBuildingsController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) HallsOfVrbansk *hallsOfVrbansk;
@property (nonatomic, retain) NSMutableArray *upgradableBuildings;


+ (ViewUpgradableBuildingsController *)create;



@end
