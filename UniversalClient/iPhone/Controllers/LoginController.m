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
#import "LEViewSectionTab.h"
#import "Session.h"
#import "KeychainItemWrapper.h"
#import "ViewEmpireProfileController.h"
#import "NewEmpireController.h"
#import "EditSavedEmpire.h"
#import "SelectServerController.h"


typedef enum {
	SECTION_LOGIN_FORM,
	SECTION_REMEMBERED_ACCOUNT,
	SECTION_CREATE_NEW,
} SECTION;

typedef enum {
	LOGIN_FORM_ROW_EMPIRE_NAME,
	LOGIN_FORM_ROW_PASSWORD,
	LOGIN_FORM_ROW_SERVER,
	LOGIN_FORM_ROW_LOGIN_BUTTON
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
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
	self.navigationItem.title = @"Empire";
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.separatorColor = SEPARATOR_COLOR;

	self.empireNameCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.empireNameCell.label.text = @"Name";
	self.empireNameCell.delegate = self;
	
	self.passwordCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.passwordCell.label.text = @"Password";
	self.passwordCell.delegate = self;
	self.passwordCell.secureTextEntry = YES;
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	Session *session = [Session sharedInstance];
	
	if (session.isLoggedIn) {
		[session logout];
	}
	
	[session addObserver:self forKeyPath:@"isLoggedIn" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	
	self.empires = session.savedEmpireList;
	if ([self.empires count] > 0) {
		self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView createWithText:@"Login"],
									 [LEViewSectionTab tableView:self.tableView createWithText:@"Empires"],
									 [NSNull null]);
	} else {
		self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView createWithText:@"Login"],
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
	Session *session = [Session sharedInstance];
	[session removeObserver:self forKeyPath:@"isLoggedIn"];
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
			return 4;
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


// Customize the appearance of table view cells.
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
				default:
					return nil;
					break;
			}
			break;
		case SECTION_REMEMBERED_ACCOUNT:
			; //DO NOT REMOVE
			NSDictionary *empireData = [self.empires objectAtIndex:indexPath.row];
			LETableViewCellButton *rememberedAccountCell = [LETableViewCellButton getCellForTableView:tableView];
			rememberedAccountCell.textLabel.text = [empireData objectForKey:@"username"];
			rememberedAccountCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
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
			self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView createWithText:@"Login"],
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
			if (indexPath.row == LOGIN_FORM_ROW_SERVER) {
				[self showServerSelect];
			} else if (indexPath.row == LOGIN_FORM_ROW_LOGIN_BUTTON) {
				if ([self.empireNameCell.textField.text length] == 0) {
					UIAlertView *noEmpireNameAlertView = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"You must enter an empire name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
					[noEmpireNameAlertView show];
				} else if ([self.passwordCell.textField.text length] == 0) {
					UIAlertView *noEmpireNameAlertView = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"You must enter a password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
					[noEmpireNameAlertView show];
				} else if (!self.selectedServer) {
					UIAlertView *noEmpireNameAlertView = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"You must select a server." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
					[noEmpireNameAlertView show];
				} else {
					[self doLogin];
				}
			}
			break;
		case SECTION_REMEMBERED_ACCOUNT:
			; //DO NOT REMOVE
			NSDictionary *empireData = [self.empires objectAtIndex:indexPath.row];
			NSString *username = [empireData objectForKey:@"username"];
			KeychainItemWrapper *keychainItemWrapper = [[[KeychainItemWrapper alloc] initWithIdentifier:username accessGroup:nil] autorelease];				
			NSString *password = [keychainItemWrapper objectForKey:(id)kSecValueData];
			session.serverUri = [keychainItemWrapper objectForKey:(id)kSecAttrService];
			if (!session.serverUri || [session.serverUri length] == 0) {
				//KEVIN REMOVE AFTER BETA
				session.serverUri = @"https://pt.lacunaexpanse.com/";
			}
			[session loginWithUsername:username password:password];
			break;
		case SECTION_CREATE_NEW:
			; //DO NOT REMOVE
			NewEmpireController *newEmpireController = [NewEmpireController create];
			UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:newEmpireController];
			navController.navigationBar.tintColor = TINT_COLOR;

			[self presentModalViewController:navController animated:YES];

			[navController release];
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
			EditSavedEmpire *editSavedEmpire = [[[EditSavedEmpire alloc] initWithNibName:@"EditSavedEmpire" bundle:nil] autorelease];
			editSavedEmpire.empireName = username;
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
    [super dealloc];
}


#pragma mark --
#pragma mark SelectServerControllerDelegate Methods

- (void)selectedServer:(NSDictionary *)server {
	self.selectedServer = server;
	[self.navigationController popViewControllerAnimated:YES];
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


#pragma mark --
#pragma mark PrivateMethods

- (void)doLogin {
	Session *session = [Session sharedInstance];
	session.serverUri = [self.selectedServer objectForKey:@"uri"];
	[session loginWithUsername:self.empireNameCell.textField.text password:self.passwordCell.textField.text];
}


- (void)showServerSelect {
	SelectServerController *selectServerController = [SelectServerController create];
	selectServerController.delegate = self;
	[self.navigationController pushViewController:selectServerController animated:YES];
}


#pragma mark -
#pragma mark KVO Methods


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ( [keyPath isEqual:@"isLoggedIn"]) {
		Session *session = (Session *)object;
		if(session.isLoggedIn) {
			[self.navigationController pushViewController:[ViewEmpireProfileController create] animated:YES];
		}
		
	}
}


@end

