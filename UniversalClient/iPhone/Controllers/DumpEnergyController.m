//
//  DumpEnergyController.m
//  UniversalClient
//
//  Created by Kevin Runde on 11/16/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "DumpEnergyController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "EnergyReserve.h"
#import "LEBuildingDump.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellNumberEntry.h"


@implementation DumpEnergyController


@synthesize energyReserve;
@synthesize amountCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Dump Energy";
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)] autorelease];
	
	Session *session = [Session sharedInstance];
	self.amountCell = [LETableViewCellNumberEntry getCellForTableView:self.tableView viewController:self maxValue:session.body.energy.current];
	self.amountCell.label.text = @"Energy";
	[self.amountCell newNumericValue:[Util decimalFromInt:0]];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Dump Energy"]);
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
	return [LETableViewCellNumberEntry getHeightForTableView:tableView];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return self.amountCell;
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
	self.energyReserve = nil;
	self.amountCell = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (void)cancel {
	[[self navigationController] popViewControllerAnimated:YES];
}


- (void)save {
	[self.energyReserve dumpEnergy:self.amountCell.numericValue	target:self callback:@selector(energyDumped:)];
}


#pragma mark -
#pragma mark Callback Methods

- (void)energyDumped:(LEBuildingDump *)request {
	if (![request wasError]) {
		[[self navigationController] popViewControllerAnimated:YES];
	}
}


#pragma mark -
#pragma mark Class Methods

+ (DumpEnergyController *)create {
	return [[[DumpEnergyController alloc] init] autorelease];
}


@end

