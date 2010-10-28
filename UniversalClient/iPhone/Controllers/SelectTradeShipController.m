//
//  SelectTradeShipController.m
//  UniversalClient
//
//  Created by Kevin Runde on 10/21/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "SelectTradeShipController.h"
#import "LEMacros.h"
#import "Util.h"
#import "BaseTradeBuilding.h"
#import "Ship.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellShip.h"


@implementation SelectTradeShipController


@synthesize baseTradeBuilding;
@synthesize delegate;
@synthesize targetBodyId;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Select Trade Ship";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.baseTradeBuilding addObserver:self forKeyPath:@"tradeShips" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	if (!self.baseTradeBuilding.tradeShips) {
		NSLog(@"Target Body ID: %@", self.targetBodyId);
		[self.baseTradeBuilding loadTradeShipsToBody:self.targetBodyId];
	} else {
		[self.baseTradeBuilding.tradeShips sortUsingDescriptors:_array([[[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES] autorelease])];
	}
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.baseTradeBuilding removeObserver:self forKeyPath:@"tradeShips"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.baseTradeBuilding && self.baseTradeBuilding.tradeShips) {
		if ([self.baseTradeBuilding.tradeShips count] > 0) {
			return [self.baseTradeBuilding.tradeShips count];
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.baseTradeBuilding && self.baseTradeBuilding.tradeShips) {
		if ([self.baseTradeBuilding.tradeShips count] > 0) {
			return [LETableViewCellShip getHeightForTableView:tableView];
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
	
	if (self.baseTradeBuilding && self.baseTradeBuilding.tradeShips) {
		if ([self.baseTradeBuilding.tradeShips count] > 0) {
			Ship *ship = [self.baseTradeBuilding.tradeShips objectAtIndex:indexPath.row];
			LETableViewCellShip *shipCell = [LETableViewCellShip getCellForTableView:tableView isSelectable:YES];
			[shipCell setShip:ship];
			cell = shipCell;
		} else {
			LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			emptyCell.label.text = @"Trade Ships";
			emptyCell.content.text = @"None";
			cell = emptyCell;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Trade Ships";
		loadingCell.content.text = @"Loading";
		cell = loadingCell;
	}
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Ship *ship = [self.baseTradeBuilding.tradeShips objectAtIndex:indexPath.row];
	[self.delegate tradeShipSelected:ship];
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
	self.targetBodyId = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Class Methods

+ (SelectTradeShipController *)create {
	return [[[SelectTradeShipController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"tradeShips"]) {
		[self.baseTradeBuilding.tradeShips sortUsingDescriptors:_array([[[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES] autorelease])];
		[self.tableView reloadData];
	}
}


@end

