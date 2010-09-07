//
//  SelectPlanController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "SelectPlanController.h"
#import "LEMacros.h"
#import "Util.h"
#import "BaseTradeBuilding.h"
#import "Plan.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellPlan.h"


@implementation SelectPlanController


@synthesize baseTradeBuilding;
@synthesize delegate;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Select Plan";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.baseTradeBuilding addObserver:self forKeyPath:@"plans" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	if (!self.baseTradeBuilding.plans) {
		[self.baseTradeBuilding loadTradeablePlans];
	} else {
		[self.baseTradeBuilding.plans sortUsingDescriptors:_array([[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES])];
	}
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.baseTradeBuilding removeObserver:self forKeyPath:@"plans"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.baseTradeBuilding && self.baseTradeBuilding.plans) {
		if ([self.baseTradeBuilding.plans count] > 0) {
			return [self.baseTradeBuilding.plans count];
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.baseTradeBuilding && self.baseTradeBuilding.plans) {
		if ([self.baseTradeBuilding.plans count] > 0) {
			return [LETableViewCellPlan getHeightForTableView:tableView];
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
	
	if (self.baseTradeBuilding && self.baseTradeBuilding.plans) {
		if ([self.baseTradeBuilding.plans count] > 0) {
			Plan *plan = [self.baseTradeBuilding.plans objectAtIndex:indexPath.row];
			LETableViewCellPlan *planCell = [LETableViewCellPlan getCellForTableView:tableView isSelectable:YES];
			[planCell setPlan:plan];
			cell = planCell;
		} else {
			LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			emptyCell.label.text = @"Plans";
			emptyCell.content.text = @"None";
			cell = emptyCell;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Plans";
		loadingCell.content.text = @"Loading";
		cell = loadingCell;
	}
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Plan *plan = [self.baseTradeBuilding.plans objectAtIndex:indexPath.row];
	[self.delegate planSelected:plan];
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
	self.baseTradeBuilding = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Class Methods

+ (SelectPlanController *)create {
	return [[[SelectPlanController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"plans"]) {
		[self.baseTradeBuilding.plans sortUsingDescriptors:_array([[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES])];
		[self.tableView reloadData];
	}
}


@end

