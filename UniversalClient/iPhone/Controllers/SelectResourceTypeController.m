//
//  SelectResourceTypeController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/21/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "SelectResourceTypeController.h"
#import "LEMacros.h"
#import "Util.h"
#import "BaseTradeBuilding.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellButton.h"


@implementation SelectResourceTypeController


@synthesize baseTradeBuilding;
@synthesize delegate;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Select Resource";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.baseTradeBuilding addObserver:self forKeyPath:@"resourceTypes" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	if (!self.baseTradeBuilding.resourceTypes) {
		[self.baseTradeBuilding loadTradeableResourceTypes];
	} else {
		[self.baseTradeBuilding.resourceTypes sortUsingSelector: @selector(caseInsensitiveCompare:)];
	}
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.baseTradeBuilding removeObserver:self forKeyPath:@"resourceTypes"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.baseTradeBuilding && self.baseTradeBuilding.resourceTypes) {
		if ([self.baseTradeBuilding.resourceTypes count] > 0) {
			return [self.baseTradeBuilding.resourceTypes count];
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.baseTradeBuilding && self.baseTradeBuilding.resourceTypes) {
		if ([self.baseTradeBuilding.resourceTypes count] > 0) {
			return [LETableViewCellButton getHeightForTableView:tableView];
		} else {
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
		}
	} else {
		return [LETableViewCellLabeledText getHeightForTableView:tableView];
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
	
	if (self.baseTradeBuilding && self.baseTradeBuilding.resourceTypes) {
		if ([self.baseTradeBuilding.resourceTypes count] > 0) {
			NSString *resourceType = [self.baseTradeBuilding.resourceTypes objectAtIndex:indexPath.row];
			LETableViewCellButton *storedResourceCell = [LETableViewCellButton getCellForTableView:tableView];
			storedResourceCell.textLabel.text = [resourceType capitalizedString];
			cell = storedResourceCell;
		} else {
			LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			emptyCell.label.text = @"Resources";
			emptyCell.content.text = @"None";
			cell = emptyCell;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView];
		loadingCell.label.text = @"Resources";
		loadingCell.content.text = @"Loading";
		cell = loadingCell;
	}
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *resourceType = [self.baseTradeBuilding.resourceTypes objectAtIndex:indexPath.row];
	[self.delegate resourceTypeSelected:resourceType];
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
	[super viewDidUnload];
}


- (void)dealloc {
	self.baseTradeBuilding = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Class Methods

+ (SelectResourceTypeController *)create {
	return [[[SelectResourceTypeController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"resourceTypes"]) {
		[self.baseTradeBuilding.resourceTypes sortUsingSelector: @selector(caseInsensitiveCompare:)];
		[self.tableView reloadData];
	}
}


@end

