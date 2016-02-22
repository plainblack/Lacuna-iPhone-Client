//
//  RenameEmpireController.m
//  UniversalClient
//
//  Created by Kevin Runde on 11/16/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "RenameEmpireController.h"
#import "LEMacros.h"
#import "Session.h"
#import "Capitol.h"
#import "LEBuildingRenameEmpire.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellParagraph.h"

#define RENAME_DESCRIPTION @"Renaming your empire cost 30 - Captial Building Level in Essentia. Since your Capitol is level %@ this will cost %@ essentia."


typedef enum {
	RENAME_EMPIRE_ROW_DESCRIPTION,
	RENAME_EMPIRE_ROW_NAME,
} RENAME_EMPIRE_ROW;


@implementation RenameEmpireController


@synthesize capitol;
@synthesize nameCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Rename Empire";
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)] autorelease];
	
	self.nameCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.nameCell.delegate = self;
	self.nameCell.label.text = @"Name";
	Session *session = [Session sharedInstance];
	self.nameCell.textField.text = session.empire.name;
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Rename Empire"]);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.nameCell becomeFirstResponder];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


// Customize the appearance of table view cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case RENAME_EMPIRE_ROW_DESCRIPTION:
			return [LETableViewCellParagraph getHeightForTableView:tableView text:[NSString stringWithFormat:RENAME_DESCRIPTION, self.capitol.level, self.capitol.renameEmpireCost]];
			break;
		case RENAME_EMPIRE_ROW_NAME:
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
			break;
		default:
			return 0.0;
			break;
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case RENAME_EMPIRE_ROW_DESCRIPTION:
			; //DO NOT REMOVE
			LETableViewCellParagraph *descriptionCell = [LETableViewCellParagraph getCellForTableView:tableView];
			descriptionCell.content.text = [NSString stringWithFormat:RENAME_DESCRIPTION, self.capitol.level, self.capitol.renameEmpireCost];
			return descriptionCell;
			break;
		case RENAME_EMPIRE_ROW_NAME:
			return self.nameCell;
			break;
		default:
			return nil;
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
    [super viewDidUnload];
}


- (void)dealloc {
	self.capitol = nil;
	self.nameCell = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (void)cancel {
	[[self navigationController] popViewControllerAnimated:YES];
}


- (void)save {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"This costs %@ essentia. Do you wish to continue?", self.capitol.renameEmpireCost] message:@"" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
		[self.capitol renameEmpire:self.nameCell.textField.text target:self callback:@selector(empireRenamed:)];
	}];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
	}];
	[alert addAction:cancelAction];
	[alert addAction:okAction];
	[self presentViewController:alert animated:YES completion:nil];
}


#pragma mark -
#pragma mark UITextFieldDelegate methods


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.nameCell.textField) {
		[self.nameCell resignFirstResponder];
		[self save];
	}
	
	return YES;
}


#pragma mark -
#pragma mark Callback Methods

- (void)empireRenamed:(LEBuildingRenameEmpire *)request {
	if (![request wasError]) {
		[[self navigationController] popViewControllerAnimated:YES];
	}
}


#pragma mark -
#pragma mark Class Methods

+ (RenameEmpireController *)create {
	return [[[RenameEmpireController alloc] init] autorelease];
}


@end

