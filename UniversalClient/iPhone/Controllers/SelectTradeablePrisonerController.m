//
//  SelectTradeablePrisonerController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/22/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "SelectTradeablePrisonerController.h"
#import "LEMacros.h"
#import "Util.h"
#import "BaseTradeBuilding.h"
#import "Prisoner.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"


@implementation SelectTradeablePrisonerController


@synthesize baseTradeBuilding;
@synthesize delegate;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Select Prisoner";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.baseTradeBuilding addObserver:self forKeyPath:@"prisoners" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	if (!self.baseTradeBuilding.prisoners) {
		[self.baseTradeBuilding loadTradeablePrisoners];
	} else {
		[self.baseTradeBuilding.prisoners sortUsingDescriptors:_array([[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES])];
	}
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.baseTradeBuilding removeObserver:self forKeyPath:@"prisoners"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.baseTradeBuilding && self.baseTradeBuilding.prisoners) {
		if ([self.baseTradeBuilding.prisoners count] > 0) {
			return [self.baseTradeBuilding.prisoners count];
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.baseTradeBuilding && self.baseTradeBuilding.prisoners) {
		if ([self.baseTradeBuilding.prisoners count] > 0) {
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
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
	
	if (self.baseTradeBuilding && self.baseTradeBuilding.prisoners) {
		if ([self.baseTradeBuilding.prisoners count] > 0) {
			Prisoner *prisoner = [self.baseTradeBuilding.prisoners objectAtIndex:indexPath.row];
			LETableViewCellLabeledText *prisonerCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:YES];
			prisonerCell.label.text = [NSString stringWithFormat:@"Level %@", prisoner.level];
			prisonerCell.content.text = prisoner.name;
			cell = prisonerCell;
		} else {
			LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			emptyCell.label.text = @"Prisoners";
			emptyCell.content.text = @"None";
			cell = emptyCell;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Prisoners";
		loadingCell.content.text = @"Loading";
		cell = loadingCell;
	}
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Prisoner *prisoner = [self.baseTradeBuilding.prisoners objectAtIndex:indexPath.row];
	[self.delegate prisonerSelected:prisoner];
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

+ (SelectTradeablePrisonerController *)create {
	return [[[SelectTradeablePrisonerController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"prisoners"]) {
		[self.baseTradeBuilding.prisoners sortUsingDescriptors:_array([[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES])];
		[self.tableView reloadData];
	}
}


@end

