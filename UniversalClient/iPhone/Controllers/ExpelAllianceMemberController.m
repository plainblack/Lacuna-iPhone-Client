//
//  ExpelAllianceMemberController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ExpelAllianceMemberController.h"
#import "LEMacros.h"
#import "Session.h"
#import "Embassy.h"
#import "AllianceMember.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellTextView.h"


@implementation ExpelAllianceMemberController


@synthesize embassy;
@synthesize messageCell;
@synthesize member;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Expel Member";
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Expel" style:UIBarButtonItemStyleDone target:self action:@selector(expelMember)] autorelease];
	
	self.messageCell = [LETableViewCellTextView getCellForTableView:self.tableView];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Empire"], [LEViewSectionTab tableView:self.tableView withText:@"Message"]);
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
		toCell.label.text = @"Empire";
		toCell.content.text = self.member.name;
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
	self.member = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (IBAction)expelMember {	
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you really sure you want to expel this member?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
		[self.embassy expelMemeber:self.member.empireId withMessage:self.messageCell.textView.text];
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

+ (ExpelAllianceMemberController *)create {
	return [[[ExpelAllianceMemberController alloc] init] autorelease];
}


@end

