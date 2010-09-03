//
//  NewEmpireController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/8/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class LETableViewCellTextEntry;
@class LETableViewCellCaptchaImage;
@class LETableViewCellButton;
@class LETableViewCellLabeledSwitch;


@interface NewEmpireController : LETableViewControllerGrouped <UITextFieldDelegate> {
	LETableViewCellTextEntry *nameCell;
	LETableViewCellTextEntry *passwordCell;
	LETableViewCellTextEntry *passwordConfirmationCell;
	LETableViewCellTextEntry *emailCell;
	LETableViewCellLabeledSwitch *termsAgreeCell;
	LETableViewCellButton *termsLinkCell;
	LETableViewCellLabeledSwitch *rulesAgreeCell;
	LETableViewCellButton *rulesLinkCell;
	LETableViewCellCaptchaImage *captchaImageCell;
	LETableViewCellTextEntry *captchaSolutionCell;
	LETableViewCellButton *nextButton;
	NSString *captchaGuid;
	NSString *captchaUrl;
	NSString *empireId;
}


@property(nonatomic, retain) LETableViewCellTextEntry *nameCell;
@property(nonatomic, retain) LETableViewCellTextEntry *passwordCell;
@property(nonatomic, retain) LETableViewCellTextEntry *passwordConfirmationCell;
@property(nonatomic, retain) LETableViewCellTextEntry *emailCell;
@property(nonatomic, retain) LETableViewCellLabeledSwitch *termsAgreeCell;
@property(nonatomic, retain) LETableViewCellButton *termsLinkCell;
@property(nonatomic, retain) LETableViewCellLabeledSwitch *rulesAgreeCell;
@property(nonatomic, retain) LETableViewCellButton *rulesLinkCell;
@property(nonatomic, retain) LETableViewCellCaptchaImage *captchaImageCell;
@property(nonatomic, retain) LETableViewCellTextEntry *captchaSolutionCell;
@property(nonatomic, retain) LETableViewCellButton *nextButton;
@property(nonatomic, retain) NSString *captchaGuid;
@property(nonatomic, retain) NSString *captchaUrl;
@property(nonatomic, retain) NSString *empireId;


- (IBAction)cancel;


+ (NewEmpireController *) create;


@end
