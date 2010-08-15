//
//  ViewAvailableTradesController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewAvailableTradesController.h"
#import "LEMacros.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "Util.h"
#import "BaseTradeBuilding.h"
#import "Trade.h"


typedef enum {
	ROW_TRADE_INFO,
} ROW;


@implementation ViewAvailableTradesController


@synthesize baseTradeBuilding;
@synthesize tradesLastUpdated;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Available Trades";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.baseTradeBuilding addObserver:self forKeyPath:@"availableTradesUpdated" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	if (!self.baseTradeBuilding.availableTrades) {
		[self.baseTradeBuilding loadAvailableTradesForPage:1];
	} else {
		if (self.tradesLastUpdated) {
			if ([self.tradesLastUpdated compare:self.baseTradeBuilding.availableTradesUpdated] == NSOrderedAscending) {
				[self.tableView reloadData];
				self.tradesLastUpdated = self.baseTradeBuilding.availableTradesUpdated;
			}
		} else {
			self.tradesLastUpdated = self.baseTradeBuilding.availableTradesUpdated;
		}
	}
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.baseTradeBuilding removeObserver:self forKeyPath:@"availableTradesUpdated"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.baseTradeBuilding && self.baseTradeBuilding.availableTrades) {
		if ([self.baseTradeBuilding.availableTrades count] > 0) {
			return [self.baseTradeBuilding.availableTrades count];
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.baseTradeBuilding && self.baseTradeBuilding.availableTrades) {
		if ([self.baseTradeBuilding.availableTrades count] > 0) {
			return 3;
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.baseTradeBuilding && self.baseTradeBuilding.availableTrades) {
		if ([self.baseTradeBuilding.availableTrades count] > 0) {
			switch (indexPath.row) {
				case ROW_TRADE_INFO:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				default:
					return tableView.rowHeight;
					break;
			}
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
	
	if (self.baseTradeBuilding && self.baseTradeBuilding.availableTrades) {
		if ([self.baseTradeBuilding.availableTrades count] > 0) {
			Trade *trade = [self.baseTradeBuilding.availableTrades objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_TRADE_INFO:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *tradeCell = [LETableViewCellLabeledText getCellForTableView:tableView];
					tradeCell.label.text = @"Trade";
					tradeCell.content.text = [NSString stringWithFormat:@"%@ : %@", trade.askDescription, trade.askDescription];
					cell = tradeCell;
					break;
				default:
					cell = nil;
					break;
			}
		} else {
			LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			emptyCell.label.text = @"Trades";
			emptyCell.content.text = @"None";
			cell = emptyCell;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView];
		loadingCell.label.text = @"Trades";
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
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	self.baseTradeBuilding = nil;
	self.tradesLastUpdated = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewAvailableTradesController *)create {
	return [[[ViewAvailableTradesController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"availableTradesUpdated"]) {
		[self.tableView reloadData];
		self.tradesLastUpdated = self.baseTradeBuilding.availableTradesUpdated;
	}
}


@end

