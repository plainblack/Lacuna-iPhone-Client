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
	ROW_NEW_PASSWORD,
	ROW_NEW_PASSWORD_CONFIRM,
	ROW_SAVE
} ROW;


@implementation NewPasswordController


@synthesize passwordCell = _passwordCell;
@synthesize passwordConfirmCell = _passwordConfirmCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"New Password";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"New Password"]);
	
	self.passwordCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.passwordCell.label.text = @"New Password";
	self.passwordCell.delegate = self;
	
	self.passwordConfirmCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.passwordConfirmCell.label.text = @"Confirm";
	self.passwordConfirmCell.delegate = self;
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
	return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
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
		case ROW_NEW_PASSWORD:
			return self.passwordCell;
			break;
		case ROW_NEW_PASSWORD_CONFIRM:
			return self.passwordConfirmCell;
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
			if ([self.passwordCell.textField.text length] == 0) {
				UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Error" message: @"You must enter the new password." preferredStyle:UIAlertControllerStyleAlert];
				UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
									 { [av dismissViewControllerAnimated:YES completion:nil]; }];
				[av addAction: ok];
				[self presentViewController:av animated:YES completion:nil];
			} else if ([self.passwordConfirmCell.textField.text length] == 0) {
				UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Error" message: @"You must enter the confirmation of the new password." preferredStyle:UIAlertControllerStyleAlert];
				UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
									 { [av dismissViewControllerAnimated:YES completion:nil]; }];
				[av addAction: ok];
				[self presentViewController:av animated:YES completion:nil];
			} else {
				Session *session = [Session sharedInstance];
				[session.empire changeToPassword:self.passwordCell.textField.text confirmPassword:self.passwordConfirmCell.textField.text target:self callback:@selector(passwordChanged:)];
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
	self.passwordCell = nil;
	self.passwordConfirmCell = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.passwordCell = nil;
	self.passwordConfirmCell = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.passwordCell.textField) {
		[self.passwordCell resignFirstResponder];
		[self.passwordConfirmCell becomeFirstResponder];
	} else if (textField == self.passwordConfirmCell.textField) {
		[self.passwordConfirmCell resignFirstResponder];
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
		[session saveToKeyChainForUsername:session.empire.name password:request.password];
		[self.navigationController popViewControllerAnimated:YES];
	}
}


#pragma mark -
#pragma mark Class Methods

+ (NewPasswordController *)create {
	return [[[NewPasswordController alloc] init] autorelease];
}


@end

