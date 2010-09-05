//
//  NewPasswordController.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class LETableViewCellTextEntry;


@interface NewPasswordController : LETableViewControllerGrouped <UITextFieldDelegate> {
	LETableViewCellTextEntry *oldPasswordCell;
	LETableViewCellTextEntry *newPasswordCell;
	LETableViewCellTextEntry *newPasswordConfirmCell;
}


@property (nonatomic, retain) LETableViewCellTextEntry *oldPasswordCell;
@property (nonatomic, retain) LETableViewCellTextEntry *newPasswordCell;
@property (nonatomic, retain) LETableViewCellTextEntry *newPasswordConfirmCell;


+ (NewPasswordController *)create;


@end
