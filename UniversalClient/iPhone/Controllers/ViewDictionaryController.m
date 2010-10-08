//
//  ViewDictionaryController.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/13/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewDictionaryController.h"
#import "LEMacros.h"
#import "Util.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellLabeledIconText.h"
#import "LETableViewCellLongLabeledText.h"


@implementation ViewDictionaryController


@synthesize data;
@synthesize keysSorted;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = self->name;
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	self.keysSorted = [[data allKeys] sortedArrayUsingSelector:@selector(compare:)];
	//Access Keys and sort them here
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return MAX([self.keysSorted count], 1);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self->useLongLabels) {
		return [LETableViewCellLongLabeledText getHeightForTableView:tableView];
	} else if (self->icon) {
		return [LETableViewCellLabeledIconText getHeightForTableView:tableView];
	} else {
		return [LETableViewCellLabeledText getHeightForTableView:tableView];
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
	if ([self.keysSorted count] > 0) {
		if (self->useLongLabels) {
			id key = [self.keysSorted objectAtIndex:indexPath.row];
			id value = [self.data objectForKey:key];
			LETableViewCellLongLabeledText *emptyCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
			emptyCell.label.text = [Util prettyCodeValue:[NSString stringWithFormat:@"%@", key]];
			emptyCell.content.text = [NSString stringWithFormat:@"%@", value];
			cell = emptyCell;
		} else if (self->icon) {
			id key = [self.keysSorted objectAtIndex:indexPath.row];
			id value = [self.data objectForKey:key];
			LETableViewCellLabeledIconText *emptyCell = [LETableViewCellLabeledIconText getCellForTableView:tableView isSelectable:NO];
			emptyCell.label.text = [Util prettyCodeValue:[NSString stringWithFormat:@"%@", key]];
			emptyCell.icon.image = self->icon;
			emptyCell.content.text = [NSString stringWithFormat:@"%@", value];
			cell = emptyCell;
		} else {
			id key = [self.keysSorted objectAtIndex:indexPath.row];
			id value = [self.data objectForKey:key];
			LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			emptyCell.label.text = [Util prettyCodeValue:[NSString stringWithFormat:@"%@", key]];
			emptyCell.content.text = [NSString stringWithFormat:@"%@", value];
			cell = emptyCell;
		}
	} else {
		LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		emptyCell.label.text = @"";
		emptyCell.content.text = @"Empty";
		cell = emptyCell;
	}
    
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
	self.keysSorted = nil;
}


- (void)dealloc {
	self.data = nil;
	self.keysSorted = nil;
	[self->name release];
	self->name = nil;
	[self->icon release];
	self->icon = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewDictionaryController *)createWithName:(NSString *)name useLongLabels:(BOOL)useLongLabels icon:(UIImage *)icon {
	ViewDictionaryController *viewDictionaryController = [[[ViewDictionaryController alloc] init] autorelease];
	viewDictionaryController->name = name;
	[viewDictionaryController->name retain];
	viewDictionaryController->icon = icon;
	[viewDictionaryController->icon retain];
	viewDictionaryController->useLongLabels = useLongLabels;
	return viewDictionaryController;
}


@end

