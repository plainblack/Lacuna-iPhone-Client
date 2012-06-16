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


@interface NewPasswordController : LETableViewControllerGrouped <UITextFieldDelegate>


@property (nonatomic, retain) LETableViewCellTextEntry *passwordCell;
@property (nonatomic, retain) LETableViewCellTextEntry *passwordConfirmCell;


+ (NewPasswordController *)create;


@end
