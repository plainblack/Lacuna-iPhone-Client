//
//  WithdrawAllianceInviteController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "WithdrawAllianceInviteController.h"
#import "LEMacros.h"
#import "Session.h"
#import "Embassy.h"
#import "PendingAllianceInvite.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellTextView.h"


@implementation WithdrawAllianceInviteController


@synthesize embassy;
@synthesize messageCell;
@synthesize invite;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Withdraw Invite";
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Withdraw" style:UIBarButtonItemStyleDone target:self action:@selector(withdrawInvite)] autorelease];
	
	self.messageCell = [LETableViewCellTextView getCellForTableView:self.tableView];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView createWithText:@"To"], [LEViewSectionTab tableView:self.tableView createWithText:@"Message"]);
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
		toCell.content.text = self.invite.name;
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
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	self.messageCell = nil;
}


- (void)dealloc {
	self.embassy = nil;
	self.invite = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (IBAction)withdrawInvite {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you really sure you want to withdraw this invite?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
	[actionSheet release];
}

#pragma mark -
#pragma mark UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.destructiveButtonIndex == buttonIndex ) {
		[self.embassy withdrawInvite:self.invite.id withMessage:self.messageCell.textView.text];
		[self.navigationController popViewControllerAnimated:YES];
	}
}


#pragma mark -
#pragma mark Class Methods

+ (WithdrawAllianceInviteController *)create {
	return [[[WithdrawAllianceInviteController alloc] init] autorelease];
}


@end
