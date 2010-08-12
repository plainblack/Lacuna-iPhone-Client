//
//  RenameShipController.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "RenameShipController.h"
#import "LEMacros.h"
#import "LEViewSectionTab.h"
#import "SpacePort.h"
#import "Ship.h"


@implementation RenameShipController


@synthesize spacePort;
@synthesize ship;
@synthesize nameCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Rename Ship";
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)] autorelease];
	
	self.nameCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.nameCell.delegate = self;
	self.nameCell.label.text = @"Name";
	self.nameCell.textField.text = self.ship.name;
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView createWithText:@"Rename Ship"]);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.ship addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.nameCell becomeFirstResponder];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	[self.ship removeObserver:self forKeyPath:@"name"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
}


- (void)dealloc {
	self.spacePort = nil;
	self.ship = nil;
	self.nameCell = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (void)cancel {
	[[self navigationController] popViewControllerAnimated:YES];
}


- (void)save {
	[self.spacePort ship:self.ship rename:self.nameCell.textField.text];
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
#pragma mark Class Methods

+ (RenameShipController *)create {
	return [[[RenameShipController alloc] init] autorelease];
}


#pragma mark --
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"name"]) {
		[self.navigationController popViewControllerAnimated:YES];
	}
}


@end

