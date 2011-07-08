//
//  ViewBattleLogsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/7/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class SpacePort;


@interface ViewBattleLogsController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) UISegmentedControl *pageSegmentedControl;
@property (nonatomic, retain) SpacePort *spacePort;
@property (nonatomic, retain) NSDate *lastUpdated;


+ (ViewBattleLogsController *) create;


@end
