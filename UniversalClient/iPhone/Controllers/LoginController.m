//
//  LoginController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/6/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LoginController.h"
#import "LEMacros.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellSavedEmpire.h"
#import "LEViewSectionTab.h"
#import "Session.h"
#import "KeychainItemWrapper.h"
#import "ViewEmpireProfileController.h"
#import "NewEmpireController.h"
#import "EditSavedEmpireV2.h"
#import "SelectServerController.h"
#import "ForgotPasswordController.h"


typedef enum {
	SECTION_LOGIN_FORM,
	SECTION_REMEMBERED_ACCOUNT,
	SECTION_CREATE_NEW,
} SECTION;

typedef enum {
	LOGIN_FORM_ROW_EMPIRE_NAME,
	LOGIN_FORM_ROW_PASSWORD,
	LOGIN_FORM_ROW_SERVER,
	LOGIN_FORM_ROW_LOGIN_BUTTON,
	LOGIN_FORM_ROW_FORGOT_PASSWORD_BUTTON
} LOGIN_FORM_ROW;


@interface LoginController(PrivateMethods)

- (void)doLogin;
- (void)showServerSelect;

@end


@implementation LoginController


@synthesize empires;
@synthesize empireNameCell;
@synthesize passwordCell;
@synthesize selectedServer;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.title = @"Empire";

	self.empireNameCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.empireNameCell.label.text = @"Name";
	self.empireNameCell.delegate = self;
	
	self.passwordCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.passwordCell.label.text = @"Password";
	self.passwordCell.delegate = self;
	self.passwordCell.secureTextEntry = YES;
	
	[KeychainItemWrapper cleanUp];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	Session *session = [Session sharedInstance];
	
	self.empires = session.savedEmpireList;
	if ([self.empires count] > 0) {
		self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Login"],
									 [LEViewSectionTab tableView:self.tableView withText:@"Empires"],
									 [NSNull null]);
	} else {
		self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Login"],
									 [NSNull null],
									 [NSNull null]);
	}

	[self.tableView reloadData];
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.empireNameCell resignFirstResponder];
	[self.passwordCell resignFirstResponder];
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
		case SECTION_LOGIN_FORM:
			return 5;
			break;
		case SECTION_REMEMBERED_ACCOUNT:
			; //DO NOT REMOVE
			Session *session = [Session sharedInstance];
			return [session.savedEmpireList count];
			break;
		case SECTION_CREATE_NEW:
			return 1;
		default:
			break;
	}
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_LOGIN_FORM:
			switch (indexPath.row) {
				case LOGIN_FORM_ROW_EMPIRE_NAME:
				case LOGIN_FORM_ROW_PASSWORD:
					return [LETableViewCellTextEntry getHeightForTableView:tableView];
					break;
				case LOGIN_FORM_ROW_SERVER:
				case LOGIN_FORM_ROW_LOGIN_BUTTON:
				case LOGIN_FORM_ROW_FORGOT_PASSWORD_BUTTON:
					return [LETableViewCellButton getHeightForTableView:tableView];
					break;
				default:
					return 0.0;
					break;
			}
			break;
		case SECTION_REMEMBERED_ACCOUNT:
			return [LETableViewCellSavedEmpire getHeightForTableView:tableView];
			break;
		case SECTION_CREATE_NEW:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		default:
			return 0.0;
			break;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	switch (indexPath.section) {
		case SECTION_LOGIN_FORM:
			switch (indexPath.row) {
				case LOGIN_FORM_ROW_EMPIRE_NAME:
					return self.empireNameCell;
					break;
				case LOGIN_FORM_ROW_PASSWORD:
					return self.passwordCell;
					break;
				case LOGIN_FORM_ROW_SERVER:
					; //DO NOT REMOVE
					LETableViewCellButton *serverCell = [LETableViewCellButton getCellForTableView:tableView];
					if (self.selectedServer) {
						serverCell.textLabel.text = [self.selectedServer objectForKey:@"name"];
					} else {
						serverCell.textLabel.text = @"Select Server";
					}
					return serverCell;
					break;
				case LOGIN_FORM_ROW_LOGIN_BUTTON:
					; //DO NOT REMOVE
					LETableViewCellButton *loginCell = [LETableViewCellButton getCellForTableView:tableView];
					loginCell.textLabel.text = @"Login";
					return loginCell;
					break;
				case LOGIN_FORM_ROW_FORGOT_PASSWORD_BUTTON:
					; //DO NOT REMOVE
					LETableViewCellButton *forgotPasswordCell = [LETableViewCellButton getCellForTableView:tableView];
					forgotPasswordCell.textLabel.text = @"Forgot Password?";
					return forgotPasswordCell;
					break;
				default:
					return nil;
					break;
			}
			break;
		case SECTION_REMEMBERED_ACCOUNT:
			; //DO NOT REMOVE
			NSDictionary *empireData = [self.empires objectAtIndex:indexPath.row];
			LETableViewCellSavedEmpire *rememberedAccountCell = [LETableViewCellSavedEmpire getCellForTableView:tableView];
			[rememberedAccountCell setData:empireData];
			return rememberedAccountCell;
			break;
		case SECTION_CREATE_NEW:
			; //DO NOT REMOVE
			LETableViewCellButton *createEmpireCell = [LETableViewCellButton getCellForTableView:tableView];
			createEmpireCell.textLabel.text = @"Create New Empire";
			return createEmpireCell;
			break;
		default:
			return nil;
			break;
	}
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return indexPath.section == SECTION_REMEMBERED_ACCOUNT;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ( (indexPath.section == SECTION_REMEMBERED_ACCOUNT) && (editingStyle == UITableViewCellEditingStyleDelete) ) {
		NSDictionary *empireData = [self.empires objectAtIndex:indexPath.row];
		Session *session = [Session sharedInstance];
		[session forgetEmpireNamed:[empireData objectForKey:@"username"]];
		self.empires = session.savedEmpireList;
		if ([self.empires count] == 0) {
			self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Login"],
										 [NSNull null],
										 [NSNull null]);
		}
		[self.tableView reloadData];
	}
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Session *session = [Session sharedInstance];

	switch (indexPath.section) {
		case SECTION_LOGIN_FORM:
			[self.empireNameCell resignFirstResponder];
			[self.passwordCell resignFirstResponder];
			switch (indexPath.row) {
				case LOGIN_FORM_ROW_SERVER:
					self->serverSelectReason = SERVER_SELECT_REASON_LOGIN;
					[self showServerSelect];
					break;
				case LOGIN_FORM_ROW_LOGIN_BUTTON:
					if ([self.empireNameCell.textField.text length] == 0) {

						UIAlertController *noEmpireNameAlertView = [UIAlertController alertControllerWithTitle:@"Error" message: @"You must enter an empire name." preferredStyle:UIAlertControllerStyleAlert];
						UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
											 { [noEmpireNameAlertView dismissViewControllerAnimated:YES completion:nil]; }];
						[noEmpireNameAlertView addAction: ok];
						[self presentViewController:noEmpireNameAlertView animated:YES completion:nil];
						
					} else if ([self.passwordCell.textField.text length] == 0) {
						UIAlertController *noEmpirePassAlertView = [UIAlertController alertControllerWithTitle:@"Error" message: @"You must enter a password." preferredStyle:UIAlertControllerStyleAlert];
						UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
											 { [noEmpirePassAlertView dismissViewControllerAnimated:YES completion:nil]; }];
						[noEmpirePassAlertView addAction: ok];
						[self presentViewController:noEmpirePassAlertView animated:YES completion:nil];
						
					} else if (!self.selectedServer) {
						UIAlertController *noEmpireServerAlertView = [UIAlertController alertControllerWithTitle:@"Error" message: @"You must select a server." preferredStyle:UIAlertControllerStyleAlert];
						UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
											 { [noEmpireServerAlertView dismissViewControllerAnimated:YES completion:nil]; }];
						[noEmpireServerAlertView addAction: ok];
						[self presentViewController:noEmpireServerAlertView animated:YES completion:nil];
						
					} else {
						[self doLogin];
					}
					break;
				case LOGIN_FORM_ROW_FORGOT_PASSWORD_BUTTON:
					; //DO NOT REMOVE
					self->serverSelectReason = SERVER_SELECT_REASON_FORGOT_PASSWORD;
					[self showServerSelect];
					break;
				default:
					break;
			}
			break;
		case SECTION_REMEMBERED_ACCOUNT:
			; //DO NOT REMOVE
			NSDictionary *empireData = [self.empires objectAtIndex:indexPath.row];
			NSString *username = [empireData objectForKey:@"username"];
			NSString *serverUri = [empireData objectForKey:@"uri"];
			KeychainItemWrapper *keychainItemWrapper = [[[KeychainItemWrapper alloc] initWithUsername:username serverUri:serverUri accessGroup:nil] autorelease];				
			NSString *password = [keychainItemWrapper objectForKey:(id)kSecValueData];
			session.serverUri = [keychainItemWrapper objectForKey:(id)kSecAttrService];
			if (!session.serverUri || [session.serverUri length] == 0) {
				//KEVIN REMOVE AFTER BETA
				session.serverUri = @"https://pt.lacunaexpanse.com/";
			}
			[session loginWithUsername:username password:password];
			[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
			break;
		case SECTION_CREATE_NEW:
			; //DO NOT REMOVE
			self->serverSelectReason = SERVER_SELECT_REASON_CREATE_EMPIRE;
			[self showServerSelect];
			break;
		default:
			break;
	}
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_REMEMBERED_ACCOUNT:
			; //DO NOT REMOVE
			NSDictionary *empireData = [self.empires objectAtIndex:indexPath.row];
			NSString *username = [empireData objectForKey:@"username"];
			NSString *uri = [empireData objectForKey:@"uri"];
			EditSavedEmpireV2 *editSavedEmpire = [EditSavedEmpireV2 create];
			editSavedEmpire.empireKey = username;
			editSavedEmpire.serverKey = uri;
			[self.navigationController pushViewController:editSavedEmpire animated:YES];

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
	self.empires = nil;
	self.empireNameCell = nil;
	self.passwordCell = nil;
	self.selectedServer = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	self.empires = nil;
	self.empireNameCell = nil;
	self.passwordCell = nil;
	self.selectedServer = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark SelectServerControllerDelegate Methods

- (void)selectedServer:(NSDictionary *)server {
	Session *session = [Session sharedInstance];
	session.serverUri = [server objectForKey:@"uri"];
	switch (self->serverSelectReason) {
		case SERVER_SELECT_REASON_CREATE_EMPIRE:
			; //DO NOT REMOVE
			NewEmpireController *newEmpireController = [NewEmpireController create];
			[self.navigationController pushViewController:newEmpireController animated:YES];
			break;
		case SERVER_SELECT_REASON_FORGOT_PASSWORD:
			; //DO NOT REMOVE
			ForgotPasswordController *forgotPasswordController = [ForgotPasswordController create];
			[self.navigationController pushViewController:forgotPasswordController animated:YES];
			break;
		case SERVER_SELECT_REASON_LOGIN:
			self.selectedServer = server;
			[self.navigationController popViewControllerAnimated:YES];
			if ([self.empireNameCell.textField.text length] > 0 && [self.passwordCell.textField.text length] > 0) {
				[self doLogin];
			}
			break;
		default:
			break;
	}
}


#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.empireNameCell.textField) {
		[self.empireNameCell resignFirstResponder];
		[self.passwordCell becomeFirstResponder];
	} else if (textField == passwordCell.textField) {
		[self.empireNameCell resignFirstResponder];
		[self.passwordCell resignFirstResponder];
		if (self.selectedServer) {
			[self doLogin];
		} else {
			[self showServerSelect];
		}
	}
	
	return YES;
}


#pragma mark -
#pragma mark PrivateMethods

- (void)doLogin {
	Session *session = [Session sharedInstance];
	[session loginWithUsername:self.empireNameCell.textField.text password:self.passwordCell.textField.text];
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


- (void)showServerSelect {
	SelectServerController *selectServerController = [SelectServerController create];
	selectServerController.delegate = self;
	[self.navigationController pushViewController:selectServerController animated:YES];
}


#pragma mark -
#pragma mark Class Methods

+ (LoginController *)create {
	return [[[LoginController alloc] init] autorelease];
}


@end

