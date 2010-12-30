//
//  PrepareExperimentController.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class GeneticsLab;
@class PrepareExperiment;


@interface PrepareExperimentController : LETableViewControllerGrouped {
}


@property(nonatomic, retain) GeneticsLab *geneticsLab;
@property(nonatomic, retain) PrepareExperiment *prepareExperiment;


+ (PrepareExperimentController *) create;


@end
