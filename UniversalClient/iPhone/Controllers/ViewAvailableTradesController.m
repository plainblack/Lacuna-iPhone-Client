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
#import "LETableViewCellButton.h"
#import "Util.h"
#import "BaseTradeBuilding.h"
#import "Trade.h"
#import "AcceptTradeController.h"


typedef enum {
	ROW_TRADE_OFFER,
	ROW_TRADE_ASK,
	ROW_ACCEPT
} ROW;


@interface ViewAvailableTradesController (PrivateMethods)

- (void)togglePageButtons;

@end


@implementation ViewAvailableTradesController


@synthesize pageSegmentedControl;
@synthesize baseTradeBuilding;
@synthesize tradesLastUpdated;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Available";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.pageSegmentedControl = [[[UISegmentedControl alloc] initWithItems:_array(UP_ARROW_ICON, DOWN_ARROW_ICON)] autorelease];
	[self.pageSegmentedControl addTarget:self action:@selector(switchPage) forControlEvents:UIControlEventValueChanged]; 
	self.pageSegmentedControl.momentary = YES;
	self.pageSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar; 
	UIBarButtonItem *rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.pageSegmentedControl] autorelease];
	self.navigationItem.rightBarButtonItem = rightBarButtonItem; 
	
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
				case ROW_TRADE_OFFER:
				case ROW_TRADE_ASK:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_ACCEPT:
					return [LETableViewCellButton getHeightForTableView:tableView];
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
				case ROW_TRADE_OFFER:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *offerCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					offerCell.label.text = @"Offer";
					offerCell.content.text = trade.offerDescription;
					cell = offerCell;
					break;
				case ROW_TRADE_ASK:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *askCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					askCell.label.text = @"Ask";
					askCell.content.text = trade.askDescription;
					cell = askCell;
					break;
				case ROW_ACCEPT:
					; //DO NOT REMOVE
					LETableViewCellButton *acceptButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					acceptButtonCell.textLabel.text = @"Accept Trade";
					cell = acceptButtonCell;
					break;
				default:
					cell = nil;
					break;
			}
		} else {
			LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			emptyCell.label.text = @"Trades";
			emptyCell.content.text = @"None";
			cell = emptyCell;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Trades";
		loadingCell.content.text = @"Loading";
		cell = loadingCell;
	}
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Trade *trade = [self.baseTradeBuilding.availableTrades objectAtIndex:indexPath.section];
	switch (indexPath.row) {
		case ROW_ACCEPT:
			; //DO NOT REMOVE
			AcceptTradeController *acceptTradeController = [AcceptTradeController create];
			acceptTradeController.baseTradeBuilding = self.baseTradeBuilding;
			acceptTradeController.trade = trade;
			[self.navigationController pushViewController:acceptTradeController animated:YES];
			break;
	}
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
	self.tradesLastUpdated = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Private Methods

- (void)togglePageButtons {
	[self.pageSegmentedControl setEnabled:[self.baseTradeBuilding hasPreviousAvailableTradePage] forSegmentAtIndex:0];
	[self.pageSegmentedControl setEnabled:[self.baseTradeBuilding hasNextAvailableTradePage] forSegmentAtIndex:1];
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
		[self togglePageButtons];
		[self.tableView reloadData];
		self.tradesLastUpdated = self.baseTradeBuilding.availableTradesUpdated;
	}
}


@end

