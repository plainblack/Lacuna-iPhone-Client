//
//  ViewPlansController.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/12/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewPlansController.h"
#import "LEMacros.h"
#import "Util.h"
#import "PlanetaryCommand.h"
#import "Plan.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellPlan.h"


@implementation ViewPlansController


@synthesize planetaryCommand;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Plans";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.planetaryCommand addObserver:self forKeyPath:@"plans" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self.planetaryCommand loadPlans];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.planetaryCommand removeObserver:self forKeyPath:@"plans"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.planetaryCommand && self.planetaryCommand.plans) {
		if ([self.planetaryCommand.plans count] > 0) {
			return [self.planetaryCommand.plans count];
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.planetaryCommand && self.planetaryCommand.plans) {
		if ([self.planetaryCommand.plans count] > 0) {
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
    
    UITableViewCell *cell = nil;
	
	if (self.planetaryCommand && self.planetaryCommand.plans) {
		if ([self.planetaryCommand.plans count] > 0) {
			Plan *plan = [self.planetaryCommand.plans objectAtIndex:indexPath.section];
			LETableViewCellPlan *planCell = [LETableViewCellPlan getCellForTableView:tableView isSelectable:NO];
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
	self.planetaryCommand = nil;
    [super dealloc];
}



#pragma mark -
#pragma mark Class Methods

+ (ViewPlansController *)create {
	return [[[ViewPlansController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"plans"]) {
		[self.tableView reloadData];
	}
}


@end

