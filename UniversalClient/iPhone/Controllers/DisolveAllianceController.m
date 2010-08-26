//
//  DisolveAllianceController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "DisolveAllianceController.h"
#import "LEMacros.h"
#import "Session.h"
#import "Embassy.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledParagraph.h"
#import "LETableViewCellButton.h"
#import "LEBuildingCreateAlliance.h"


@implementation DisolveAllianceController


@synthesize embassy;
@synthesize warningCell;
@synthesize disolveButtonCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Disolve Alliance";
	
	self.warningCell = [LETableViewCellLabeledParagraph getCellForTableView:self.tableView];
	self.warningCell.label.text = @"Name";
	self.warningCell.content.text = @"You are about to disolve your whole alliance. This cannot be undone. If this is what you really truly intended to do then select Disolve Alliance below. If not press Back in the upper left corner.";
	
	self.disolveButtonCell = [LETableViewCellButton getCellForTableView:self.tableView];
	self.disolveButtonCell.textLabel.text = @"Disolve Alliance";
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView createWithText:@"Disolve Alliance"]);
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}


// Customize the appearance of table view cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case 0:
			return [LETableViewCellLabeledParagraph getHeightForTableView:tableView text:self.warningCell.content.text];
			break;
		case 1:
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
		case 0:
			return self.warningCell;
			break;
		case 1:
			return self.disolveButtonCell;
			break;
		default:
			return nil;
			break;
	}
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you really sure you want to disolve this alliance? This cannot be undone." delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
	[actionSheet release];
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
	self.warningCell = nil;
	self.disolveButtonCell = nil;
}


- (void)dealloc {
	self.embassy = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (void)disolveAlliance {
	[self.embassy disolveAlliance];
}

#pragma mark -
#pragma mark UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.destructiveButtonIndex == buttonIndex ) {
		[self disolveAlliance];
		[self.navigationController popViewControllerAnimated:YES];
	}
}


#pragma mark -
#pragma mark Class Methods

+ (DisolveAllianceController *)create {
	return [[[DisolveAllianceController alloc] init] autorelease];
}


@end

