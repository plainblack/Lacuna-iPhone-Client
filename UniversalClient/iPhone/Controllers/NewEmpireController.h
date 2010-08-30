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


@interface NewEmpireController : LETableViewControllerGrouped <UITextFieldDelegate> {
	LETableViewCellTextEntry *nameCell;
	LETableViewCellTextEntry *passwordCell;
	LETableViewCellTextEntry *passwordConfirmationCell;
	LETableViewCellTextEntry *emailCell;
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
@property(nonatomic, retain) LETableViewCellCaptchaImage *captchaImageCell;
@property(nonatomic, retain) LETableViewCellTextEntry *captchaSolutionCell;
@property(nonatomic, retain) LETableViewCellButton *nextButton;
@property(nonatomic, retain) NSString *captchaGuid;
@property(nonatomic, retain) NSString *captchaUrl;
@property(nonatomic, retain) NSString *empireId;


+ (NewEmpireController *) create;


@end
