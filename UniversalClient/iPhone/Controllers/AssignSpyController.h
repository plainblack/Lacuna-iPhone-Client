//
//  AssignSpyController.h
//  UniversalClient
//
//  Created by Kevin Runde on 1/5/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class Intelligence;
@class Spy;


@interface AssignSpyController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) Intelligence *intelligence;
@property (nonatomic, retain) Spy *spy;
@property (nonatomic, retain) NSDictionary *assignedMission;


+ (AssignSpyController *) create;


@end
