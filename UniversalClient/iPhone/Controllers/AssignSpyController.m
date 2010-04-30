//
//  AssignSpyController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "AssignSpyController.h"
#import "LEMacros.h"
#import "LEBuildingAssignSpy.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellSpyInfo.h"


typedef enum {
	ROW_SPY_INFO
} ROW;


@implementation AssignSpyController


@synthesize buildingId;
@synthesize spyData;
@synthesize urlPart;
@synthesize possibleAssignments;
@synthesize assignmentPicker;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Assign Spy";
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)] autorelease];
	
	self.assignmentPicker = [[[UIPickerView alloc] init] autorelease];
	self.assignmentPicker.dataSource = self;
	self.assignmentPicker.delegate = self;
	self.assignmentPicker.showsSelectionIndicator = YES;
	
	self.sectionHeaders = [NSArray array];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.possibleAssignments = [self.possibleAssignments sortedArrayUsingSelector:@selector(compare:)];
	self.sectionHeaders = array_([LEViewSectionTab tableView:self.tableView createWithText:[self.spyData objectForKey:@"name"]]);
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	if (self.spyData) {
		return 1;
	}  else {
		return 0;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.spyData) {
		return 1;
	} else {
		return 0;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	if (section == 0) {
		return self.assignmentPicker.bounds.size.height;
	} else {
		return 0;
	}
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	if (section == 0) {
		return self.assignmentPicker;
	} else {
		return nil;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case ROW_SPY_INFO:
			return [LETableViewCellSpyInfo getHeightForTableView:tableView];
			break;
		default:
			return tableView.rowHeight;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
	
	switch (indexPath.row) {
		case ROW_SPY_INFO:
			; //DO NOT REMOVE
			LETableViewCellSpyInfo *spyInfoCell = [LETableViewCellSpyInfo getCellForTableView:tableView];
			[spyInfoCell setData:self.spyData];
			cell = spyInfoCell;
			break;
		default:
			break;
	}
    
    return cell;
}


#pragma mark -
#pragma mark UIViewPicker Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.possibleAssignments count];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [self.possibleAssignments objectAtIndex:row];
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
    self.assignmentPicker = nil;
}


- (void)dealloc {
	self.buildingId = nil;
	self.spyData = nil;
	self.urlPart = nil;
	self.possibleAssignments = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (void)cancel {
	[[self navigationController] popViewControllerAnimated:YES];
}


- (void)save {
	NSInteger row = [self.assignmentPicker selectedRowInComponent:0];
	NSString *assignment = [self.possibleAssignments objectAtIndex:row];
	[[[LEBuildingAssignSpy alloc] initWithCallback:@selector(spyAssigned:) target:self buildingId:self.buildingId buildingUrl:self.urlPart spyId:[self.spyData objectForKey:@"id"] assignment:assignment] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (id)spyAssigned:(LEBuildingAssignSpy *)request {
	[[self navigationController] popViewControllerAnimated:YES];
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (AssignSpyController *)create {
	return [[[AssignSpyController alloc] init] autorelease];
}


@end

