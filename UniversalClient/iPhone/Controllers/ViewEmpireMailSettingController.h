//
//  ViewEmpireMailSettingController.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/23/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "LETableViewCellLabeledSwitch.h"


@class EmpireProfile;


@interface ViewEmpireMailSettingController : LETableViewControllerGrouped <LETableViewCellLabeledSwitchDelegate> {
}


@property (nonatomic, retain) LETableViewCellLabeledSwitch *skipHappinessWarningsCell;
@property (nonatomic, retain) LETableViewCellLabeledSwitch *skipResourceWarningsCell;
@property (nonatomic, retain) LETableViewCellLabeledSwitch *skipPollutionWarningsCell;
@property (nonatomic, retain) LETableViewCellLabeledSwitch *skipMedalMessagesCell;
@property (nonatomic, retain) LETableViewCellLabeledSwitch *skipFacebookWallPostsCell;
@property (nonatomic, retain) LETableViewCellLabeledSwitch *skipFoundNothingCell;
@property (nonatomic, retain) LETableViewCellLabeledSwitch *skipExcavatorResourcesCell;
@property (nonatomic, retain) LETableViewCellLabeledSwitch *skipExcavatorGlyphCell;
@property (nonatomic, retain) LETableViewCellLabeledSwitch *skipExcavatorPlanCell;
@property (nonatomic, retain) LETableViewCellLabeledSwitch *skipSpyRecoveryCell;
@property (nonatomic, retain) LETableViewCellLabeledSwitch *skipProbeDetectedCell;
@property (nonatomic, retain) LETableViewCellLabeledSwitch *skipAttackMessagesCell;
@property (nonatomic, retain) EmpireProfile *empireProfile;


+ (ViewEmpireMailSettingController *)create;



@end
