//
//  ForgotPasswordController.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/2/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class LETableViewCellTextEntry;


@interface ForgotPasswordController : LETableViewControllerGrouped <UITextFieldDelegate> {
	LETableViewCellTextEntry *emailCell;
	LETableViewCellTextEntry *resetCodeCell;
	LETableViewCellTextEntry *passwordCell;
	LETableViewCellTextEntry *passwordConfirmationCell;
}


@property (nonatomic, retain) LETableViewCellTextEntry *emailCell;
@property (nonatomic, retain) LETableViewCellTextEntry *resetCodeCell;
@property (nonatomic, retain) LETableViewCellTextEntry *passwordCell;
@property (nonatomic, retain) LETableViewCellTextEntry *passwordConfirmationCell;


+ (ForgotPasswordController *)create;


@end
