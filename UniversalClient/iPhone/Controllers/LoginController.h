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


@interface LoginController : LETableViewControllerGrouped <UITextFieldDelegate, SelectServerControllerDelegate> {
	NSArray *empires;
	LETableViewCellTextEntry *empireNameCell;
	LETableViewCellTextEntry *passwordCell;
	NSDictionary *selectedServer;
	BOOL createNewAccount;
}


@property(nonatomic, retain) NSArray *empires;
@property(nonatomic, retain) LETableViewCellTextEntry *empireNameCell;
@property(nonatomic, retain) LETableViewCellTextEntry *passwordCell;
@property(nonatomic, retain) NSDictionary *selectedServer;


+ (LoginController *)create;

@end
