//
//  LeaveAllianceController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LeaveAllianceController.h"
#import "LEMacros.h"
#import "Session.h"
#import "Embassy.h"
#import "AllianceStatus.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellTextView.h"


@implementation LeaveAllianceController


@synthesize embassy;
@synthesize messageCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Leave Alliance";
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Leave" style:UIBarButtonItemStyleDone target:self action:@selector(leaveAlliance)] autorelease];
	
	self.messageCell = [LETableViewCellTextView getCellForTableView:self.tableView];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"To"], [LEViewSectionTab tableView:self.tableView withText:@"Message"]);
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


// Customize the appearance of table view cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
			break;
		case 1:
			return [LETableViewCellTextView getHeightForTableView:tableView];
			break;
		default:
			return 0.0;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		LETableViewCellLabeledText *toCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO]; 
		toCell.label.text = @"To";
		toCell.content.text = self.embassy.allianceStatus.leaderName;
		return toCell;
	} else {
		return self.messageCell;
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
	self.messageCell = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.messageCell = nil;
	self.embassy = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (IBAction)leaveAlliance {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Are you really sure you want to leave the alliance." preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
		[self.embassy leaveAllianceWithMessage:self.messageCell.textView.text];
		[self.navigationController popViewControllerAnimated:YES];
	}];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
	}];
	[alert addAction:cancelAction];
	[alert addAction:okAction];
	[self presentViewController:alert animated:YES completion:nil];
}


#pragma mark -
#pragma mark Class Methods

+ (LeaveAllianceController *)create {
	return [[[LeaveAllianceController alloc] init] autorelease];
}


@end

