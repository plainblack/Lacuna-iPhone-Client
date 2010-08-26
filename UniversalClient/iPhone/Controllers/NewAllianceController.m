//
//  NewAllianceController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "NewAllianceController.h"
#import "LEMacros.h"
#import "Session.h"
#import "Embassy.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellTextEntry.h"
#import "LEBuildingCreateAlliance.h"


@implementation NewAllianceController


@synthesize embassy;
@synthesize nameCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"New Alliance";
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStyleDone target:self action:@selector(createAlliance)] autorelease];
	
	self.nameCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.nameCell.delegate = self;
	self.nameCell.label.text = @"Name";
	
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView createWithText:@"New Alliance"]);
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.nameCell becomeFirstResponder];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.nameCell;
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
	self.nameCell = nil;
}


- (void)dealloc {
	self.embassy = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (void)createAlliance {
	[self.embassy createAllianceWithName:self.nameCell.textField.text target:self callback:@selector(allianceCreated:)];
}


#pragma mark -
#pragma mark Callback Methods

- (id)allianceCreated:(LEBuildingCreateAlliance *)request {
	[[self navigationController] popViewControllerAnimated:YES];
	return nil;
}


#pragma mark -
#pragma mark UITextFieldDelegate methods


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.nameCell.textField) {
		[self.nameCell resignFirstResponder];
		[self createAlliance];
	}
	
	return YES;
}


#pragma mark -
#pragma mark Class Methods

+ (NewAllianceController *)create {
	return [[[NewAllianceController alloc] init] autorelease];
}


@end

