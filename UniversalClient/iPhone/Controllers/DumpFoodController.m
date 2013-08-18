//
//  DumpFoodController.m
//  UniversalClient
//
//  Created by Kevin Runde on 11/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "DumpFoodController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "FoodReserve.h"
#import "LEBuildingDump.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellNumberEntry.h"
#import "SelectResourceTypeFromListController.h"


@implementation DumpFoodController


@synthesize foodReserve;
@synthesize typeToDump;
@synthesize amountToDump;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Dump Food";
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)] autorelease];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Dump Food"]);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
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
    return 1;
}


// Customize the appearance of table view cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case 0:
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
			; //DO NOT REMOVE
			LETableViewCellButton *selectResourceTypeCell = [LETableViewCellButton getCellForTableView:tableView];
			if (self.typeToDump && self.amountToDump) {
				selectResourceTypeCell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", [self.typeToDump capitalizedString], [Util prettyNSDecimalNumber:self.amountToDump]];
			} else {
				selectResourceTypeCell.textLabel.text = @"Select Resource Type";
			}
			
			return selectResourceTypeCell;
			break;
		default:
			return nil;
			break;
	}
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case 0:
			; //DO NOT REMOVE
			SelectResourceTypeFromListController *selectResourceTypeFromListController = [SelectResourceTypeFromListController create];
			selectResourceTypeFromListController.storedResourceTypes = self.foodReserve.storedFood;
			selectResourceTypeFromListController.delegate = self;
			[self.navigationController pushViewController:selectResourceTypeFromListController animated:YES];
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
	self.foodReserve = nil;
	self.typeToDump = nil;
	self.amountToDump = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (void)cancel {
	[[self navigationController] popViewControllerAnimated:YES];
}


- (void)save {
	[self.foodReserve dumpFood:self.amountToDump type:self.typeToDump target:self callback:@selector(foodDumped:)];
}


#pragma mark -
#pragma mark SelectResourceTypeFromListControllerDelegate

- (void)selectedStoredResourceType:(NSString *)type amount:(NSDecimalNumber *)amount {
	self.typeToDump = type;
	self.amountToDump = amount;
	[self.navigationController popToViewController:self animated:YES];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Callback Methods

- (void)foodDumped:(LEBuildingDump *)request {
	if (![request wasError]) {
		[[self navigationController] popViewControllerAnimated:YES];
	}
}


#pragma mark -
#pragma mark Class Methods

+ (DumpFoodController *)create {
	return [[[DumpFoodController alloc] init] autorelease];
}


@end

