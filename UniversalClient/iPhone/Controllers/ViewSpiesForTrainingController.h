//
//  ViewSpiesForTrainingController.h
//  UniversalClient
//
//  Created by Kevin Runde on 5/30/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class SpyTraining;
@class Spy;


@interface ViewSpiesForTrainingController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) UISegmentedControl *pageSegmentedControl;
@property (nonatomic, retain) SpyTraining *spyTraining;
@property (nonatomic, retain) NSDate *spiesLastUpdated;
@property (nonatomic, retain) Spy *selectedSpy;


+ (ViewSpiesForTrainingController *) create;


@end
