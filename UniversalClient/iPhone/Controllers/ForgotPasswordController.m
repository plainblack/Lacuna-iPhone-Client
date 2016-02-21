//
//  ForgotPasswordController.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/2/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ForgotPasswordController.h"
#import "LEMacros.h"
#import "Session.h"
#import "KeychainItemWrapper.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellParagraph.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellTextEntry.h"
#import "LEEmpireSendPasswordResetMessage.h"
#import "LEEmpireResetPassword.h"

#define INSTRUCTION_TEXT @"Instructions go here."


typedef enum {
	SECTION_INSTRUCTIONS,
	SECTION_REQUEST_RESET_CODE,
	SECTION_RESET_PASSWORD
} SECTION;


typedef enum {
	REQUEST_ROW_EMAIL,
	REQUEST_ROW_SEND_BUTTON
} REQUEST_ROW;


typedef enum {
	RESET_ROW_RESET_CODE,
	RESET_ROW_PASSWORD,
	RESET_ROW_PASSWORD_CONFIRMATION,
	RESET_ROW_BUTTON
} RESET_ROW;


@implementation ForgotPasswordController


@synthesize emailCell;
@synthesize resetCodeCell;
@synthesize passwordCell;
@synthesize passwordConfirmationCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.title = @"Forgot Password";
	
	self.emailCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.emailCell.label.text = @"Email";
	self.emailCell.keyboardType = UIKeyboardTypeEmailAddress;
	self.emailCell.delegate = self;
	
	self.resetCodeCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.resetCodeCell.label.text = @"Reset Code";
	self.resetCodeCell.delegate = self;
	
	self.passwordCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.passwordCell.label.text = @"Password";
	self.passwordCell.delegate = self;
	self.passwordCell.secureTextEntry = YES;

	self.passwordConfirmationCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.passwordConfirmationCell.label.text = @"Confirm";
	self.passwordConfirmationCell.delegate = self;
	self.passwordConfirmationCell.secureTextEntry = YES;
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Instructions"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Request Code"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Reset Password"]);
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case SECTION_INSTRUCTIONS:
			return 1;
			break;
		case SECTION_REQUEST_RESET_CODE:
			return 2;
			break;
		case SECTION_RESET_PASSWORD:
			return 4;
		default:
			return 0;
			break;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_INSTRUCTIONS:
			return [LETableViewCellParagraph getHeightForTableView:tableView text:INSTRUCTION_TEXT];
			break;
		case SECTION_REQUEST_RESET_CODE:
			switch (indexPath.row) {
				case REQUEST_ROW_EMAIL:
					return [LETableViewCellTextEntry getHeightForTableView:tableView];
					break;
				case REQUEST_ROW_SEND_BUTTON:
					return [LETableViewCellButton getHeightForTableView:tableView];
					break;
				default:
					return 0.0;
					break;
			}
			break;
		case SECTION_RESET_PASSWORD:
			switch (indexPath.row) {
				case RESET_ROW_RESET_CODE:
				case RESET_ROW_PASSWORD:
				case RESET_ROW_PASSWORD_CONFIRMATION:
					return [LETableViewCellTextEntry getHeightForTableView:tableView];
					break;
				case RESET_ROW_BUTTON:
					return [LETableViewCellButton getHeightForTableView:tableView];
					break;
				default:
					return 0.0;
					break;
			}
			break;
		default:
			return 0.0;
			break;
	}
}

	
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_INSTRUCTIONS:
			; //DO NOT REMOVE
			LETableViewCellParagraph *instructionCell = [LETableViewCellParagraph getCellForTableView:tableView];
			instructionCell.content.text = INSTRUCTION_TEXT;
			return instructionCell;
			break;
		case SECTION_REQUEST_RESET_CODE:
			switch (indexPath.row) {
				case REQUEST_ROW_EMAIL:
					return self.emailCell;
					break;
				case REQUEST_ROW_SEND_BUTTON:
					; //DO NOT REMOVE
					LETableViewCellButton *sendRequestButton = [LETableViewCellButton getCellForTableView:tableView];
					sendRequestButton.textLabel.text = @"Request Reset Code";
					return sendRequestButton;
					break;
				default:
					return nil;
					break;
			}
			break;
		case SECTION_RESET_PASSWORD:
			switch (indexPath.row) {
				case RESET_ROW_RESET_CODE:
					return self.resetCodeCell;
					break;
				case RESET_ROW_PASSWORD:
					return self.passwordCell;
					break;
				case RESET_ROW_PASSWORD_CONFIRMATION:
					return self.passwordConfirmationCell;
					break;
				case RESET_ROW_BUTTON:
					; //DO NOT REMOVE
					LETableViewCellButton *setPasswordButton = [LETableViewCellButton getCellForTableView:tableView];
					setPasswordButton.textLabel.text = @"Set Password";
					return setPasswordButton;
					break;
				default:
					return nil;
					break;
			}
			break;
		default:
			return nil;
			break;
	}
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_REQUEST_RESET_CODE:
			switch (indexPath.row) {
				case REQUEST_ROW_SEND_BUTTON:
					; //DO NOT REMOVE
					[[[LEEmpireSendPasswordResetMessage alloc] initWithCallback:@selector(passwordResetMessageSent:) target:self empireId:nil empireName:nil emailAddress:self.emailCell.textField.text] autorelease];
					self.pendingRequest = YES;
					break;
			}
			break;
		case SECTION_RESET_PASSWORD:
			switch (indexPath.row) {
				case RESET_ROW_BUTTON:
					; //DO NOT REMOVE
					[[[LEEmpireResetPassword alloc]	initWithCallback:@selector(passwordReset:) target:self resetKey:self.resetCodeCell.textField.text password:self.passwordCell.textField.text passwordConfirmation:self.passwordConfirmationCell.textField.text] autorelease];
					self.pendingRequest = YES;
					break;
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
	self.emailCell = nil;
	self.resetCodeCell = nil;
	self.passwordCell = nil;
	self.passwordConfirmationCell = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	self.emailCell = nil;
	self.resetCodeCell = nil;
	self.passwordCell = nil;
	self.passwordConfirmationCell = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.emailCell.textField) {
		[self.emailCell resignFirstResponder];
	} else if (textField == self.resetCodeCell.textField) {
		[self.resetCodeCell resignFirstResponder];
		[self.passwordCell becomeFirstResponder];
	} else if (textField == self.passwordCell.textField) {
		[self.passwordCell resignFirstResponder];
		[self.passwordConfirmationCell becomeFirstResponder];
	} else if (textField == self.passwordConfirmationCell.textField) {
		[self.passwordConfirmationCell resignFirstResponder];
	}
	
	return YES;
}
//89fe0527-5c39-42b6-8a2c-017998545303

#pragma mark -
#pragma mark Callback Methods

- (id)passwordResetMessageSent:(LEEmpireSendPasswordResetMessage *)request {
	self.pendingRequest = NO;
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];

	if ([request wasError]) {
		[request markErrorHandled];
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Alert" message: @"That email address is not associtate with any empire." preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
	} else {
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Email Sent" message: @"A email with password reset instructions has been sent. Please check your email." preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
	}

	return nil;
}


- (id)passwordReset:(LEEmpireResetPassword *)request {
	self.pendingRequest = NO;
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];

	if ([request wasError]) {
		[request markErrorHandled];
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Alert" message:[request errorMessage] preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
	} else {
		Session *session = [Session sharedInstance];
		[session loggedInEmpireData:request.empireData sessionId:request.sessionId password:request.password];
	}

	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (ForgotPasswordController *)create {
	return [[[ForgotPasswordController alloc] init] autorelease];
}


@end

