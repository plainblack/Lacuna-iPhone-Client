//
//  ViewMiningFleetShips.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/1/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewMiningFleetShipsController.h"
#import "Util.h"
#import "MiningMinistry.h"
#import "Ship.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellShip.h"
#import "LETableViewCellButton.h"


typedef enum {
	ROW_SHIP_INFO,
	ROW_ADD_OR_REMOVE
} ROW;


@implementation ViewMiningFleetShipsController


@synthesize miningMinistry;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Fleet Ships";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.miningMinistry addObserver:self forKeyPath:@"fleetShips" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self.miningMinistry loadFleetShips];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.miningMinistry removeObserver:self forKeyPath:@"fleetShips"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.miningMinistry && self.miningMinistry.fleetShips) {
		if ([self.miningMinistry.fleetShips count] > 0) {
			return [self.miningMinistry.fleetShips count];
		} else {
			return 1;
		}
		
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.miningMinistry && self.miningMinistry.fleetShips) {
		if ([self.miningMinistry.fleetShips count] > 0) {
			return 2;
		} else {
			return 1;
		}
		
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.miningMinistry && self.miningMinistry.fleetShips) {
		if ([self.miningMinistry.fleetShips count] > 0) {
			switch (indexPath.row) {
				case ROW_SHIP_INFO:
					return [LETableViewCellShip getHeightForTableView:tableView];
					break;
				case ROW_ADD_OR_REMOVE:
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
	
	if (self.miningMinistry && self.miningMinistry.fleetShips) {
		if ([self.miningMinistry.fleetShips count] > 0) {
			Ship *ship = [self.miningMinistry.fleetShips objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_SHIP_INFO:
					; //DO NOT REMOVE
					LETableViewCellShip *shipCell = [LETableViewCellShip getCellForTableView:tableView isSelectable:NO];
					[shipCell setShip:ship];
					cell = shipCell;
					break;
				case ROW_ADD_OR_REMOVE:
					; //DO NOT REMOVE
					LETableViewCellButton *addRemoveCell = [LETableViewCellButton getCellForTableView:tableView];
					if ([ship.task isEqualToString:@"Mining"]) {
						addRemoveCell.textLabel.text = @"Remove from Fleet";
					} else {
						addRemoveCell.textLabel.text = @"Add to Fleet";
					}
					cell = addRemoveCell;
					break;
				default:
					cell = nil;
					break;
			}
		} else {
			LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			loadingCell.label.text = @"Ships";
			loadingCell.content.text = @"None";
			cell = loadingCell;
		}
		
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"";
		loadingCell.content.text = @"Loading";
		cell = loadingCell;
	}
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.miningMinistry && self.miningMinistry.fleetShips) {
		if ([self.miningMinistry.fleetShips count] > 0) {
			Ship *ship = [self.miningMinistry.fleetShips objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_ADD_OR_REMOVE:
					if ([ship.task isEqualToString:@"Mining"]) {
						[self.miningMinistry removeCargoShipFromFleet:ship];
					} else {
						[self.miningMinistry addCargoShipToFleet:ship];
					}
					[self.tableView reloadData];
					break;
			}
		}
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
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	self.miningMinistry = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewMiningFleetShipsController *)create {
	return [[[ViewMiningFleetShipsController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"fleetShips"]) {
		[self.tableView reloadData];
	}
}


@end

