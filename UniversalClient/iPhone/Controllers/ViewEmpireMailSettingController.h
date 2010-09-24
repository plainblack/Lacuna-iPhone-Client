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
	LETableViewCellLabeledSwitch *skipHappinessWarningsCell;
	LETableViewCellLabeledSwitch *skipResourceWarningsCell;
	LETableViewCellLabeledSwitch *skipPollutionWarningsCell;
	LETableViewCellLabeledSwitch *skipMedalMessagesCell;
	EmpireProfile *empireProfile;
}


@property (nonatomic, retain) LETableViewCellLabeledSwitch *skipHappinessWarningsCell;
@property (nonatomic, retain) LETableViewCellLabeledSwitch *skipResourceWarningsCell;
@property (nonatomic, retain) LETableViewCellLabeledSwitch *skipPollutionWarningsCell;
@property (nonatomic, retain) LETableViewCellLabeledSwitch *skipMedalMessagesCell;
@property (nonatomic, retain) EmpireProfile *empireProfile;


+ (ViewEmpireMailSettingController *)create;



@end
