//
//  LoginController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/6/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "LETableViewCellTextEntry.h"
#import "SelectServerController.h"


typedef enum {
	SERVER_SELECT_REASON_LOGIN,
	SERVER_SELECT_REASON_CREATE_EMPIRE,
	SERVER_SELECT_REASON_FORGOT_PASSWORD
} SERVER_SELECT_REASON;

@interface LoginController : LETableViewControllerGrouped <UITextFieldDelegate, SelectServerControllerDelegate> {
	NSArray *empires;
	LETableViewCellTextEntry *empireNameCell;
	LETableViewCellTextEntry *passwordCell;
	NSDictionary *selectedServer;
	SERVER_SELECT_REASON serverSelectReason;
}


@property(nonatomic, retain) NSArray *empires;
@property(nonatomic, retain) LETableViewCellTextEntry *empireNameCell;
@property(nonatomic, retain) LETableViewCellTextEntry *passwordCell;
@property(nonatomic, retain) NSDictionary *selectedServer;


+ (LoginController *)create;


@end
