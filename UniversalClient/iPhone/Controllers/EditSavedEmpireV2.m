//
//  EditSavedEmpireV2.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "EditSavedEmpireV2.h"
#import "LEMacros.h"
#import "LEViewSectionTab.h"
#import "Session.h"
#import "KeychainItemWrapper.h"
#import "LETableViewCellButton.h"
#import "SelectServerController.h"


typedef enum {
	LOGIN_FORM_ROW_EMPIRE_NAME,
	LOGIN_FORM_ROW_PASSWORD,
	LOGIN_FORM_ROW_SERVER,
	LOGIN_FORM_ROW_LOGIN_BUTTON,
} LOGIN_FORM_ROW;


@interface EditSavedEmpireV2(PrivateMethods)

- (void)doLogin;
- (void)showServerSelect;

@end



@implementation EditSavedEmpireV2


@synthesize empireKey;
@synthesize serverKey;
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
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)] autorelease];
	self.navigationItem.title = @"Saved Empire";

	self.empireNameCell = [LETableViewCellLabeledText getCellForTableView:self.tableView isSelectable:NO];
	self.empireNameCell.label.text = @"Name";
	
	self.passwordCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.passwordCell.label.text = @"Password";
	self.passwordCell.delegate = self;
	self.passwordCell.secureTextEntry = YES;
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Empire"]);
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	Session *session = [Session sharedInstance];
	
	if (!self.selectedServer) {
		KeychainItemWrapper *keychainItemWrapper = [[[KeychainItemWrapper alloc] initWithUsername:self.empireKey serverUri:self.serverKey accessGroup:nil] autorelease];

		if (isNotEmptyString([keychainItemWrapper objectForKey:(id)kSecAttrAccount])) {
			self.empireNameCell.content.text = [keychainItemWrapper objectForKey:(id)kSecAttrAccount];
		} else {
			self.empireNameCell.content.text = self.empireKey;
		}

		self.passwordCell.textField.text = [keychainItemWrapper objectForKey:(id)kSecValueData];

		if (isNotEmptyString([keychainItemWrapper objectForKey:(id)kSecAttrService])) {
			session.serverUri = [keychainItemWrapper objectForKey:(id)kSecAttrService];
		} else {
			session.serverUri = self.serverKey;
		}
		self.selectedServer = _dict(session.serverUri, @"name", session.serverUri, @"uri");
	}
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
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 4;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
			serverCell.textLabel.font = LABEL_FONT;
			if (self.selectedServer) {
				serverCell.textLabel.text = [self.selectedServer objectForKey:@"uri"];
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
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.empireNameCell resignFirstResponder];
	[self.passwordCell resignFirstResponder];
	switch (indexPath.row) {
		case LOGIN_FORM_ROW_SERVER:
			[self showServerSelect];
			break;
		case LOGIN_FORM_ROW_LOGIN_BUTTON:
			if ([self.passwordCell.textField.text length] == 0) {
				UIAlertController *noEmpireNameAlertView = [UIAlertController alertControllerWithTitle:@"Error" message: @"You must enter a password." preferredStyle:UIAlertControllerStyleAlert];
				UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
									 { [noEmpireNameAlertView dismissViewControllerAnimated:YES completion:nil]; }];
				[noEmpireNameAlertView addAction: ok];
				[self presentViewController:noEmpireNameAlertView animated:YES completion:nil];
			} else if (!self.selectedServer) {
				UIAlertController *noEmpireNameAlertView = [UIAlertController alertControllerWithTitle:@"Error" message: @"You must select a server." preferredStyle:UIAlertControllerStyleAlert];
				UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
									 { [noEmpireNameAlertView dismissViewControllerAnimated:YES completion:nil]; }];
				[noEmpireNameAlertView addAction: ok];
				[self presentViewController:noEmpireNameAlertView animated:YES completion:nil];
			} else {
				[self doLogin];
			}
			break;
		default:
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
	self.empireNameCell = nil;
	self.passwordCell = nil;
	self.selectedServer = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	self.empireKey = nil;
	self.serverKey = nil;
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
	self.selectedServer = server;
	[self.navigationController popViewControllerAnimated:YES];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == passwordCell.textField) {
		[self.passwordCell resignFirstResponder];
	}
	
	return YES;
}


#pragma mark -
#pragma mark PrivateMethods

- (void)doLogin {
	Session *session = [Session sharedInstance];
	[session loginWithUsername:self.empireNameCell.content.text password:self.passwordCell.textField.text];
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


- (void)showServerSelect {
	SelectServerController *selectServerController = [SelectServerController create];
	selectServerController.delegate = self;
	[self.navigationController pushViewController:selectServerController animated:YES];
}


#pragma mark -
#pragma mark Action Methods

- (IBAction)save {
	NSLog(@"Creating wrapper to save");
	KeychainItemWrapper *keychainItemWrapper = [[[KeychainItemWrapper alloc] initWithUsername:self.empireKey serverUri:[self.selectedServer objectForKey:@"uri"] accessGroup:nil] autorelease];
	NSLog(@"Saving");
	[keychainItemWrapper setObject:self.passwordCell.textField.text forKey:(id)kSecValueData];
	//[keychainItemWrapper setObject:[self.selectedServer objectForKey:@"uri"] forKey:(id)kSecAttrService];
	
	Session *session = [Session sharedInstance];
	[session updatedSavedEmpire:self.empireNameCell.content.text uri:[self.selectedServer objectForKey:@"uri"]];
	
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Class Methods

+ (EditSavedEmpireV2 *)create {
	return [[[EditSavedEmpireV2 alloc] init] autorelease];
}


@end

