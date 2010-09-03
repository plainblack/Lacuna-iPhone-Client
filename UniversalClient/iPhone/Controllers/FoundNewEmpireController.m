//
//  ConfirmNewEmpireController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "FoundNewEmpireController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellTextEntry.h"
#import "LETableViewCellButton.h"
#import "LEEmpireFound.h"


typedef enum {
	ROW_FRIEND_CODE,
	ROW_FOUND_BUTTON
} ROW;


@implementation FoundNewEmpireController


@synthesize friendCodeCell;
@synthesize foundButtonCell;
@synthesize empireId;
@synthesize username;
@synthesize password;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Found Empire";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
	self.hidesBottomBarWhenPushed = YES;
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView createWithText:@"Found Empire"]);
	
	self.friendCodeCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.friendCodeCell.label.text = @"Friend Code";
	self.friendCodeCell.delegate = self;
	
	self.foundButtonCell = [LETableViewCellButton getCellForTableView:self.tableView];
	self.foundButtonCell.textLabel.text = @"Found Empire";
	}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case ROW_FRIEND_CODE:
			return [LETableViewCellTextEntry getHeightForTableView:tableView];
			break;
		case ROW_FOUND_BUTTON:
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
		case ROW_FRIEND_CODE:
			return self.friendCodeCell;
			break;
		case ROW_FOUND_BUTTON:
			return self.foundButtonCell;
			break;
		default:
			return nil;
			break;
	}
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.pendingRequest) {
		switch (indexPath.row) {
			case ROW_FOUND_BUTTON:
				self.pendingRequest = YES;
				[[[LEEmpireFound alloc] initWithCallback:@selector(empireFounded:) target:self empireId:self.empireId inviteCode:self.friendCodeCell.textField.text] autorelease];
				break;
		}
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
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	self.friendCodeCell = nil;
	self.foundButtonCell = nil;
	[self viewDidUnload];
}


- (void)dealloc {
	self.empireId = nil;
	self.username = nil;
	self.password = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark UITextFieldDelegate methods


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.friendCodeCell.textField) {
		[self.friendCodeCell resignFirstResponder];
	}
	
	return YES;
}


#pragma mark -
#pragma mark Instance Methods

- (IBAction)cancel {
	[self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Callbacks

- (id)empireFounded:(LEEmpireFound *) request {
	self.pendingRequest = NO;
	if ([request wasError]) {
		//WHAT TO DO?
	} else {
		[self.navigationController popToRootViewControllerAnimated:YES];
		Session *session = [Session sharedInstance];
		[session loginWithUsername:self.username password:self.password];
	}
	
	return nil;
}

#pragma mark -
#pragma mark Class Methods

+ (FoundNewEmpireController *) create {
	return [[[FoundNewEmpireController alloc] init] autorelease];
}


@end

