//
//  ViewPlansController.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/12/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "BuildingWithPlans.h"


@class Building;


@interface ViewPlansController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) NSObject<BuildingWithPlans> *buildingWithPlans;


+ (ViewPlansController *) create;


@end
