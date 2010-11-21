//
//  ViewMissionsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 11/6/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LETableViewControllerGrouped.h"


@class MissionCommand;
@class Mission;


@interface ViewMissionsController : LETableViewControllerGrouped <UIActionSheetDelegate> {
}


@property (nonatomic, retain) MissionCommand *missionCommand;
@property (nonatomic, retain) Mission *skipMission;


+ (ViewMissionsController *)create;

@end
