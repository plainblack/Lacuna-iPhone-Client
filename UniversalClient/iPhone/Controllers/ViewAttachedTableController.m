//
//  ViewAttachedTableController.m
//  UniversalClient
//
//  Created by Kevin Runde on 5/3/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewAttachedTableController.h"
#import "LETableViewCellLabeledText.h"


@implementation ViewAttachedTableController


@synthesize headers;
@synthesize sections;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	self.navigationItem.title = @"Table";
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSInteger numSections = [self.sections count];
	if (numSections == 0) {
		return 1;
	} else {
		return numSections;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger numSections = [self.sections count];
	if (numSections == 0) {
		return 0;
	} else {
		return [self.headers count];
	}
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSInteger numSections = [self.sections count];
	if (numSections == 0) {
		return @"Table is empty";
	} else {
		NSArray *sectionData = [self.sections objectAtIndex:section];
		return [sectionData objectAtIndex:0];
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSArray *section = [self.sections objectAtIndex:indexPath.section];

	LETableViewCellLabeledText *cell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
	cell.label.text = [self.headers objectAtIndex:indexPath.row];
	cell.content.text = [section objectAtIndex:indexPath.row];

    return cell;
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
	self.headers = nil;
	self.sections = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Memory management

- (void)setAttachedTable:(NSArray *)attachedTable{
	self.headers = [attachedTable objectAtIndex:0];
	self.sections = [attachedTable subarrayWithRange:NSMakeRange(1, ([attachedTable count]-1))];
}


@end

