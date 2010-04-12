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
#import "ViewEmpireController.h"
#import "NewEmpireController.h"


typedef enum {
	SECTION_LOGIN_FORM,
	SECTION_REMEMBERED_ACCOUNT,
	SECTION_CREATE_NEW,
} SECTION;


@implementation LoginController


@synthesize empires;
@synthesize empireNameCell;
@synthesize passwordCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
	self.navigationItem.title = @"Empire";
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.separatorColor = LE_BLUE;

	self.empireNameCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.empireNameCell.label.text = @"Name";
	self.empireNameCell.delegate = self;
	
	self.passwordCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.passwordCell.label.text = @"Password";
	self.passwordCell.delegate = self;
	self.passwordCell.secureTextEntry = YES;
	
	self.sectionHeaders = array_([LEViewSectionTab tableView:self.tableView createWithText:@"Login"],
								 [LEViewSectionTab tableView:self.tableView createWithText:@"Empires"],
								 [NSNull null]);

}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	Session *session = [Session sharedInstance];
	
	if (session.isLoggedIn) {
		[session logout];
	}
	
	[session addObserver:self forKeyPath:@"isLoggedIn" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	
	self.empires = session.empireList;
	[self.tableView reloadData];
	
	self.empireNameCell.textField.text = @"";
	self.passwordCell.textField.text = @"";
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
			return 3;
			break;
		case SECTION_REMEMBERED_ACCOUNT:
			; //DO NOT REMOVE
			Session *session = [Session sharedInstance];
			return [session.empireList count];
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
				case 0:
					return self.empireNameCell;
					break;
				case 1:
					return self.passwordCell;
					break;
				case 2:
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
			NSLog(@"empireDate: %@", empireData);
			LETableViewCellButton *rememberedAccountCell = [LETableViewCellButton getCellForTableView:tableView];
			rememberedAccountCell.textLabel.text = [empireData objectForKey:@"username"];
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
		self.empires = session.empireList;
		[self.tableView reloadData];
	}
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Session *session = [Session sharedInstance];

	switch (indexPath.section) {
		case SECTION_LOGIN_FORM:
			if (indexPath.row == 2) {
				[self.empireNameCell resignFirstResponder];
				[self.passwordCell resignFirstResponder];
				[session loginWithUsername:self.empireNameCell.textField.text password:self.passwordCell.textField.text];
			}
			break;
		case SECTION_REMEMBERED_ACCOUNT:
			; //DO NOT REMOVE
			NSDictionary *empireData = [self.empires objectAtIndex:indexPath.row];
			NSString *username = [empireData objectForKey:@"username"];
			NSString *password;
			if ([username isEqualToString:@"bob57"]) {
				password = @"abc123";
			} else {
				NSLog(@"Looking up: %@", username);
				KeychainItemWrapper *keychainItemWrapper = [[[KeychainItemWrapper alloc] initWithIdentifier:username accessGroup:nil] autorelease];
				password = [keychainItemWrapper objectForKey:(id)kSecValueData];
			}
			
			[session loginWithUsername:username password:password];
			break;
		case SECTION_CREATE_NEW:
			; //DO NOT REMOVE
			NewEmpireController *newEmpireController = [NewEmpireController create];
			UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:newEmpireController];
			navController.navigationBar.tintColor = LE_BLUE;

			[self presentModalViewController:navController animated:YES];

			[navController release];
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
	self.empires = nil;
	self.empireNameCell = nil;
	self.passwordCell = nil;
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark -
#pragma mark UITextFieldDelegate methods


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.empireNameCell.textField) {
		[self.empireNameCell resignFirstResponder];
		[self.passwordCell becomeFirstResponder];
	} else if (textField == passwordCell.textField) {
		[self.passwordCell resignFirstResponder];
		Session *session = [Session sharedInstance];
		[session loginWithUsername:self.empireNameCell.textField.text password:self.passwordCell.textField.text];
	}
	
	return YES;
}


#pragma mark -
#pragma mark KVO Methods


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ( [keyPath isEqual:@"isLoggedIn"]) {
		Session *session = (Session *)object;
		if(session.isLoggedIn) {
			NSLog(@"LOGGED IN");
			[self.navigationController pushViewController:[ViewEmpireController create]
												 animated:YES];
		}
		
	}
}


@end

