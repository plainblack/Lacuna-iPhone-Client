//
//  ViewEmpireController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/8/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "LETableViewCellLabeledSwitch.h"
#import "EditTextFieldController.h"

@class LEEmpireViewProfile;
@class EmpireProfile;


@interface ViewEmpireProfileController : LETableViewControllerGrouped <LETableViewCellLabeledSwitchDelegate, EditTextFieldControllerDelegate> {
	LEEmpireViewProfile *leEmpireViewProfile;
	EmpireProfile *empireProfile;
}


@property(nonatomic, retain) LEEmpireViewProfile *leEmpireViewProfile;
@property(nonatomic, retain) EmpireProfile *empireProfile;


- (IBAction)logout;


+ (ViewEmpireProfileController *) create;


@end
