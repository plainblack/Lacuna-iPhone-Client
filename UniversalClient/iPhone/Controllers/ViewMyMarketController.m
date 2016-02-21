//
//  ViewMyMarketController.m
//  UniversalClient
//
//  Created by Kevin Runde on 12/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewMyMarketController.h"
#import "LEMacros.h"
#import "Util.h"
#import "BaseTradeBuilding.h"
#import "MarketTrade.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellLabeledIconText.h"
#import "LETableViewCellLabeledParagraph.h"
#import "LETableViewCellButton.h"


typedef enum {
	ROW_TRADE_OFFER,
	ROW_TRADE_ASK,
	ROW_WITHDRAW
} ROW;


@interface ViewMyMarketController (PrivateMethods)

- (void)togglePageButtons;

@end


@implementation ViewMyMarketController


@synthesize pageSegmentedControl;
@synthesize baseTradeBuilding;
@synthesize myMarketLastUpdated;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"My Market";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.pageSegmentedControl = [[[UISegmentedControl alloc] initWithItems:_array(UP_ARROW_ICON, DOWN_ARROW_ICON)] autorelease];
	[self.pageSegmentedControl addTarget:self action:@selector(switchPage) forControlEvents:UIControlEventValueChanged]; 
	self.pageSegmentedControl.momentary = YES;
	UIBarButtonItem *rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.pageSegmentedControl] autorelease];
	self.navigationItem.rightBarButtonItem = rightBarButtonItem; 
	
	self.sectionHeaders = [NSArray array];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.baseTradeBuilding addObserver:self forKeyPath:@"myMarketUpdated" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	if (!self.baseTradeBuilding.myMarketTrades) {
		[self.baseTradeBuilding loadMyMarketPage:1];
	} else {
		if (self.myMarketLastUpdated) {
			if ([self.myMarketLastUpdated compare:self.baseTradeBuilding.myMarketUpdated] == NSOrderedAscending) {
				[self.tableView reloadData];
				self.myMarketLastUpdated = self.baseTradeBuilding.myMarketUpdated;
			}
		} else {
			self.myMarketLastUpdated = self.baseTradeBuilding.myMarketUpdated;
		}
	}
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.baseTradeBuilding removeObserver:self forKeyPath:@"myMarketUpdated"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.baseTradeBuilding && self.baseTradeBuilding.myMarketTrades) {
		if ([self.baseTradeBuilding.myMarketTrades count] > 0) {
			return [self.baseTradeBuilding.myMarketTrades count];
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.baseTradeBuilding && self.baseTradeBuilding.myMarketTrades) {
		if ([self.baseTradeBuilding.myMarketTrades count] > 0) {
			return 3;
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.baseTradeBuilding && self.baseTradeBuilding.myMarketTrades) {
		if ([self.baseTradeBuilding.myMarketTrades count] > 0) {
			MarketTrade *trade = [self.baseTradeBuilding.myMarketTrades objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_TRADE_OFFER:
					return [LETableViewCellLabeledParagraph getHeightForTableView:tableView text:trade.offerText];
					break;
				case ROW_TRADE_ASK:
					return [LETableViewCellLabeledIconText getHeightForTableView:tableView];
					break;
				case ROW_WITHDRAW:
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
    
    UITableViewCell *cell = nil;
	
	if (self.baseTradeBuilding && self.baseTradeBuilding.myMarketTrades) {
		if ([self.baseTradeBuilding.myMarketTrades count] > 0) {
			MarketTrade *trade = [self.baseTradeBuilding.myMarketTrades objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_TRADE_OFFER:
					; //DO NOT REMOVE
					LETableViewCellLabeledParagraph *offerCell = [LETableViewCellLabeledParagraph getCellForTableView:tableView];
					offerCell.label.text = @"Offer";
					offerCell.content.text = trade.offerText;
					cell = offerCell;
					break;
				case ROW_TRADE_ASK:
					; //DO NOT REMOVE
					LETableViewCellLabeledIconText *askCell = [LETableViewCellLabeledIconText getCellForTableView:tableView isSelectable:NO];
					askCell.label.text = @"Ask";
					askCell.icon.image = ESSENTIA_ICON;
					askCell.content.text = [Util prettyNSDecimalNumber:trade.askEssentia];
					cell = askCell;
					break;
				case ROW_WITHDRAW:
					; //DO NOT REMOVE
					LETableViewCellButton *withdrawButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					withdrawButtonCell.textLabel.text = @"Withdraw Trade";
					cell = withdrawButtonCell;
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
	MarketTrade *trade = [self.baseTradeBuilding.myMarketTrades objectAtIndex:indexPath.section];
	switch (indexPath.row) {
		case ROW_WITHDRAW:
			[self.baseTradeBuilding withdrawMarketTrade:trade];
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
	self.myMarketLastUpdated = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Private Methods

- (void)togglePageButtons {
	[self.pageSegmentedControl setEnabled:[self.baseTradeBuilding hasPreviousMyMarketPage] forSegmentAtIndex:0];
	[self.pageSegmentedControl setEnabled:[self.baseTradeBuilding hasNextMyMarketPage] forSegmentAtIndex:1];
}


#pragma mark -
#pragma mark Callback Methods

- (void) switchPage {
	switch (self.pageSegmentedControl.selectedSegmentIndex) {
		case 0:
			[self.baseTradeBuilding loadMyMarketPage:(self.baseTradeBuilding.myMarketPageNumber-1)];
			break;
		case 1:
			[self.baseTradeBuilding loadMyMarketPage:(self.baseTradeBuilding.myMarketPageNumber+1)];
			break;
		default:
			NSLog(@"Invalid switchPage");
			break;
	}
}


#pragma mark -
#pragma mark Class Methods

+ (ViewMyMarketController *)create {
	return [[[ViewMyMarketController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"myMarketUpdated"]) {
		[self togglePageButtons];
		[self.tableView reloadData];
		self.myMarketLastUpdated = self.baseTradeBuilding.myMarketUpdated;
	}
}


@end

