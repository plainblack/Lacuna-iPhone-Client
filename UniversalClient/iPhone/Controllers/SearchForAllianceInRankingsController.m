//
//  SearchForAllianceInRankingsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 10/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "SearchForAllianceInRankingsController.h"
#import "LEMacros.h"
#import "Session.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellTextEntry.h"
#import "LEStatsFindAllianceRank.h"


typedef enum {
	SECTION_SEARCH,
	SECTION_ALLIANCES
} SECTION;


@implementation SearchForAllianceInRankingsController


@synthesize sortBy;
@synthesize alliances;
@synthesize delegate;
@synthesize nameCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Search For Alliance";
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Search"], [LEViewSectionTab tableView:self.tableView withText:@"Matches"]);
	
	self.nameCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	[self.nameCell setReturnKeyType:UIReturnKeySearch];
	self.nameCell.delegate = self;
	self.nameCell.label.text = @"Alliance Name";
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
		case SECTION_ALLIANCES:
			if (self.alliances && [self.alliances count] > 0) {
				return [self.alliances count];
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
		case SECTION_ALLIANCES:
			if (self.alliances && [self.alliances count] > 0) {
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
		case SECTION_ALLIANCES:
			if (self.alliances) {
				if ([self.alliances count] > 0) {
					NSDictionary *alliance = [self.alliances objectAtIndex:indexPath.row];
					LETableViewCellButton *allianceButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					allianceButtonCell.textLabel.text = [alliance objectForKey:@"alliance_name"];
					cell = allianceButtonCell;
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
	if (indexPath.section == SECTION_ALLIANCES) {
		NSDictionary *alliance = [self.alliances objectAtIndex:indexPath.row];
		[delegate selectedAlliance:alliance];
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
	self.sortBy = nil;
	self.nameCell = nil;
	self.alliances = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (void)searchForAlliance:(NSString *)allianceName {
	[[[LEStatsFindAllianceRank alloc] initWithCallback:@selector(alliancesFound:) target:self sortBy:self.sortBy allianceName:allianceName] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (void)alliancesFound:(LEStatsFindAllianceRank *)request {
	self.alliances = request.alliances;
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if ([textField.text length] > 2) {
		[self searchForAlliance:textField.text];
		return YES;
	} else {
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Error" message: @"You must enter at least 3 characters to search." preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
		return NO;
	}
}


#pragma mark -
#pragma mark Class Methods

+ (SearchForAllianceInRankingsController *)create {
	return [[[SearchForAllianceInRankingsController alloc] init] autorelease];
}


@end

