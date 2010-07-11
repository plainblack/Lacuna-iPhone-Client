//
//  AssignSpyController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "AssignSpyController.h"
#import "LEMacros.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellSpyInfo.h"
#import "Intelligence.h"
#import "Spy.h"


typedef enum {
	ROW_SPY_INFO
} ROW;


@implementation AssignSpyController


@synthesize intelligenceBuilding;
@synthesize spy;
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
	
	self.tableView.tableFooterView = self.assignmentPicker;
	
	self.sectionHeaders = _array([NSNull null]);
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.spy addObserver:self forKeyPath:@"assignment" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:YES];
	[self.spy removeObserver:self forKeyPath:@"assignment"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	if (self.spy) {
		return 1;
	}  else {
		return 0;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.spy) {
		return 1;
	} else {
		return 0;
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
			[spyInfoCell setData:self.spy];
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
    return [self.intelligenceBuilding.possibleAssignments count];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [self.intelligenceBuilding.possibleAssignments objectAtIndex:row];
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
	self.intelligenceBuilding = nil;
	self.spy = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (void)cancel {
	[[self navigationController] popViewControllerAnimated:YES];
}


- (void)save {
	NSInteger row = [self.assignmentPicker selectedRowInComponent:0];
	NSString *assignment = [self.intelligenceBuilding.possibleAssignments objectAtIndex:row];
	[self.intelligenceBuilding spy:self.spy assign:assignment];
}


#pragma mark -
#pragma mark Class Methods

+ (AssignSpyController *)create {
	return [[[AssignSpyController alloc] init] autorelease];
}


#pragma mark --
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"assignment"]) {
		[self.navigationController popViewControllerAnimated:YES];
	}
}


@end

