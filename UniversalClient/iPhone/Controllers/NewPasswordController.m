//
//  NewPasswordController.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "NewPasswordController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellTextEntry.h"
#import "LETableViewCellButton.h"
#import "LEEmpireChangePassword.h"


typedef enum {
	ROW_OLD_PASSWORD,
	ROW_NEW_PASSWORD,
	ROW_NEW_PASSWORD_CONFIRM,
	ROW_SAVE
} ROW;


@implementation NewPasswordController


@synthesize oldPasswordCell;
@synthesize newPasswordCell;
@synthesize newPasswordConfirmCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"New Password";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"New Password"]);
	
	self.oldPasswordCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.oldPasswordCell.label.text = @"Password";
	self.oldPasswordCell.delegate = self;
	
	self.newPasswordCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.newPasswordCell.label.text = @"New Password";
	self.newPasswordCell.delegate = self;
	
	self.newPasswordConfirmCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.newPasswordConfirmCell.label.text = @"Confirm";
	self.newPasswordConfirmCell.delegate = self;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 4;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case ROW_OLD_PASSWORD:
		case ROW_NEW_PASSWORD:
		case ROW_NEW_PASSWORD_CONFIRM:
			return [LETableViewCellTextEntry getHeightForTableView:tableView];
			break;
		case ROW_SAVE:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		default:
			return 0.0;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case ROW_OLD_PASSWORD:
			return self.oldPasswordCell;
			break;
		case ROW_NEW_PASSWORD:
			return self.newPasswordCell;
			break;
		case ROW_NEW_PASSWORD_CONFIRM:
			return self.newPasswordConfirmCell;
			break;
		case ROW_SAVE:
			; //DO NOT REMOVE
			LETableViewCellButton *saveButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			saveButtonCell.textLabel.text = @"Set Password";
			return saveButtonCell;
			break;
		default:
			return nil;
			break;
	}
}


#pragma mark -
#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case ROW_SAVE:
			if ([self.oldPasswordCell.textField.text length] == 0) {
				UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"You must enter your current password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
				[av show];
			} else if ([self.newPasswordCell.textField.text length] == 0) {
				UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"You must enter the new password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
				[av show];
			} else if ([self.newPasswordConfirmCell.textField.text length] == 0) {
				UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"You must enter the confirmation of the new password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
				[av show];
			} else {
				Session *session = [Session sharedInstance];
				[session.empire changeFromPassword:self.oldPasswordCell.textField.text toPassword:self.newPasswordCell.textField.text confirmPassword:self.newPasswordConfirmCell.textField.text target:self callback:@selector(passwordChanged:)];
			}
			break;
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.oldPasswordCell = nil;
	self.newPasswordCell = nil;
	self.newPasswordConfirmCell = nil;
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.oldPasswordCell.textField) {
		[self.oldPasswordCell resignFirstResponder];
		[self.newPasswordCell becomeFirstResponder];
	} else if (textField == self.newPasswordCell.textField) {
		[self.newPasswordCell resignFirstResponder];
		[self.newPasswordConfirmCell becomeFirstResponder];
	} else if (textField == self.newPasswordConfirmCell.textField) {
		[self.newPasswordConfirmCell resignFirstResponder];
	}
	return YES;
}


#pragma mark -
#pragma mark Callback Methods

- (void)passwordChanged:(LEEmpireChangePassword *)request {
	if ([request wasError]) {
		//Let generic error handler do pop up.
	} else {
		Session *session = [Session sharedInstance];
		[session saveToKeyChainForUsername:session.empire.name password:request.newPassword];
		[self.navigationController popViewControllerAnimated:YES];
	}
}


#pragma mark -
#pragma mark Class Methods

+ (NewPasswordController *)create {
	return [[[NewPasswordController alloc] init] autorelease];
}


@end

