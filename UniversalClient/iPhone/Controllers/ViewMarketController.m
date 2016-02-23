//
//  ViewMarketController.m
//  UniversalClient
//
//  Created by Kevin Runde on 12/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewMarketController.h"
#import "LEMacros.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellLabeledIconText.h"
#import "LETableViewCellLabeledParagraph.h"
#import "LETableViewCellButton.h"
#import "Util.h"
#import "BaseTradeBuilding.h"
#import "MarketTrade.h"
#import "AcceptMarketTradeController.h"
#import "LEBuildingAcceptFromMarket.h"


typedef enum {
	ROW_TRADE_OFFER,
	ROW_TRADE_ASK,
	ROW_ACCEPT
} ROW;


@interface ViewMarketController (PrivateMethods)

- (void)togglePageButtons;

@end


@implementation ViewMarketController


@synthesize pageSegmentedControl;
@synthesize baseTradeBuilding;
@synthesize marketLastUpdated;
@synthesize selectedTrade;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Available";
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
	[self.baseTradeBuilding addObserver:self forKeyPath:@"marketUpdated" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	if (!self.baseTradeBuilding.marketTrades) {
		[self.baseTradeBuilding loadMarketPage:1 filter:self.baseTradeBuilding.marketFilter];
	} else {
		if (self.marketLastUpdated) {
			if ([self.marketLastUpdated compare:self.baseTradeBuilding.marketUpdated] == NSOrderedAscending) {
				[self.tableView reloadData];
				self.marketLastUpdated = self.baseTradeBuilding.marketUpdated;
			}
		} else {
			self.marketLastUpdated = self.baseTradeBuilding.marketUpdated;
		}
	}
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.baseTradeBuilding removeObserver:self forKeyPath:@"marketUpdated"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.baseTradeBuilding && self.baseTradeBuilding.marketTrades) {
		if ([self.baseTradeBuilding.marketTrades count] > 0) {
			return [self.baseTradeBuilding.marketTrades count];
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.baseTradeBuilding && self.baseTradeBuilding.marketTrades) {
		if ([self.baseTradeBuilding.marketTrades count] > 0) {
			return 3;
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.baseTradeBuilding && self.baseTradeBuilding.marketTrades) {
		if ([self.baseTradeBuilding.marketTrades count] > 0) {
			MarketTrade *trade = [self.baseTradeBuilding.marketTrades objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_TRADE_OFFER:
					return [LETableViewCellLabeledParagraph getHeightForTableView:tableView text:trade.offerText];
					break;
				case ROW_TRADE_ASK:
					return [LETableViewCellLabeledIconText getHeightForTableView:tableView];
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
    UITableViewCell *cell = nil;
	
	if (self.baseTradeBuilding && self.baseTradeBuilding.marketTrades) {
		if ([self.baseTradeBuilding.marketTrades count] > 0) {
			MarketTrade *trade = [self.baseTradeBuilding.marketTrades objectAtIndex:indexPath.section];
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
	MarketTrade *trade = [self.baseTradeBuilding.marketTrades objectAtIndex:indexPath.section];
	switch (indexPath.row) {
		case ROW_ACCEPT:
			if (self.baseTradeBuilding.selectTradeShip) {
				AcceptMarketTradeController *acceptMarketTradeController = [AcceptMarketTradeController create];
				acceptMarketTradeController.baseTradeBuilding = self.baseTradeBuilding;
				acceptMarketTradeController.trade = trade;
				[self.navigationController pushViewController:acceptMarketTradeController animated:YES];
			} else {
				self.selectedTrade = trade;
				[self.baseTradeBuilding acceptMarketTrade:self.selectedTrade target:self callback:@selector(tradeAccepted:)];
			}

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
	self.pageSegmentedControl = nil;
}


- (void)dealloc {
	self.pageSegmentedControl = nil;
	self.baseTradeBuilding = nil;
	self.marketLastUpdated = nil;
	self.selectedTrade = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Private Methods

- (void)togglePageButtons {
	[self.pageSegmentedControl setEnabled:[self.baseTradeBuilding hasPreviousMarketPage] forSegmentAtIndex:0];
	[self.pageSegmentedControl setEnabled:[self.baseTradeBuilding hasNextMarketPage] forSegmentAtIndex:1];
}


#pragma mark -
#pragma mark Callback Methods

- (void) switchPage {
	switch (self.pageSegmentedControl.selectedSegmentIndex) {
		case 0:
			[self.baseTradeBuilding loadMarketPage:(self.baseTradeBuilding.marketPageNumber-1) filter:self.baseTradeBuilding.marketFilter];
			break;
		case 1:
			[self.baseTradeBuilding loadMarketPage:(self.baseTradeBuilding.marketPageNumber+1) filter:self.baseTradeBuilding.marketFilter];
			break;
		default:
			NSLog(@"Invalid switchPage");
			break;
	}
}


- (id)tradeAccepted:(LEBuildingAcceptFromMarket *)request {
	if ([request wasError]) {
		NSString *errorText = [request errorMessage];
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Could not accept trade." message:errorText preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
		
		[request markErrorHandled];
		[self.tableView reloadData];
		
	} else {
		[self.baseTradeBuilding.marketTrades removeObject:self.selectedTrade];
		[self.navigationController popViewControllerAnimated:YES];
	}
	
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (ViewMarketController *)create {
	return [[[ViewMarketController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"marketUpdated"]) {
		[self togglePageButtons];
		[self.tableView reloadData];
		self.marketLastUpdated = self.baseTradeBuilding.marketUpdated;
	}
}


@end

