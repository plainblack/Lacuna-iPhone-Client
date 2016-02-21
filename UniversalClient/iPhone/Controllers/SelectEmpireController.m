//
//  SelectEmpireController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "SelectEmpireController.h"
#import "LEMacros.h"
#import "Session.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellTextEntry.h"
#import "LEEmpireFind.h"


typedef enum {
	SECTION_SEARCH,
	SECTION_EMPIRES
} SECTION;


@implementation SelectEmpireController


@synthesize empires;
@synthesize delegate;
@synthesize nameCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Select Empire";
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Search"], [LEViewSectionTab tableView:self.tableView withText:@"Matches"]);

	self.nameCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	[self.nameCell setReturnKeyType:UIReturnKeySearch];
	self.nameCell.delegate = self;
	self.nameCell.label.text = @"Empire Name";
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.nameCell becomeFirstResponder];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case SECTION_SEARCH:
			return 1;
			break;
		case SECTION_EMPIRES:
			if (self.empires && [self.empires count] > 0) {
				return [self.empires count];
			} else {
				return 1;
			}
			break;
		default:
			return 0;
			break;
	}
}


// Customize the appearance of table view cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_SEARCH:
			return [LETableViewCellTextEntry getHeightForTableView:tableView];
			break;
		case SECTION_EMPIRES:
			if (self.empires && [self.empires count] > 0) {
				return [LETableViewCellLabeledText getHeightForTableView:tableView];
			} else {
				return [LETableViewCellButton getHeightForTableView:tableView];
			}
			break;
		default:
			return 0.0;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
	switch (indexPath.section) {
		case SECTION_SEARCH:
			; // DO NOT REMOVE
			cell = self.nameCell;
			break;
		case SECTION_EMPIRES:
			if (self.empires) {
				if ([self.empires count] > 0) {
					NSDictionary *empire = [self.empires objectAtIndex:indexPath.row];
					LETableViewCellButton *empireButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					empireButtonCell.textLabel.text = [empire objectForKey:@"name"];
					cell = empireButtonCell;
				} else {
					LETableViewCellLabeledText *noMatchesCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					noMatchesCell.content.text = @"No Matches";
					cell = noMatchesCell;
				}

			} else {
				LETableViewCellLabeledText *searchCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				searchCell.content.text = @"Enter a name";
				cell = searchCell;
			}
			break;
		default:
			cell = nil;
			break;
	}
	
	return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == SECTION_EMPIRES) {
		NSDictionary *empire = [self.empires objectAtIndex:indexPath.row];
		[delegate selectedEmpire:empire];
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
	self.nameCell = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.nameCell = nil;
	self.empires = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (void)searchForEmpire:(NSString *)empireName {
	[[[LEEmpireFind alloc] initWithCallback:@selector(empiresFound:) target:self empireName:empireName] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (void)empiresFound:(LEEmpireFind *)request {
	self.empires = request.empiresFound;
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if ([textField.text length] > 2) {
		[self searchForEmpire:textField.text];
		return YES;
	} else {
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Error" message: @"YYou must enter at least 3 characters to search." preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
		return NO;
	}
}


#pragma mark -
#pragma mark Class Methods

+ (SelectEmpireController *)create {
	return [[[SelectEmpireController alloc] init] autorelease];
}


@end

