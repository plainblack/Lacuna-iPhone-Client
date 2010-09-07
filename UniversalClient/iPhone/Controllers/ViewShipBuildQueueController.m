//
//  ViewShipBuildQueueController.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewShipBuildQueueController.h"
#import "Util.h"
#import "Shipyard.h"
#import "ShipBuildQueueItem.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellShipBuildQueueItem.h"


typedef enum {
	ROW_SHIP_BUILD_QUEUE_ITEM
} ROW;


@implementation ViewShipBuildQueueController


@synthesize shipyard;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Ship Build Queue";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.shipyard addObserver:self forKeyPath:@"buildQueue" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self.shipyard loadBuildQueue];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.shipyard removeObserver:self forKeyPath:@"buildQueue"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.shipyard && self.shipyard.buildQueue) {
		if ([self.shipyard.buildQueue count] > 0) {
			return [self.shipyard.buildQueue count];
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
	if (self.shipyard && self.shipyard.buildQueue) {
		if ([self.shipyard.buildQueue count] > 0) {
			switch (indexPath.row) {
				case ROW_SHIP_BUILD_QUEUE_ITEM:
					return [LETableViewCellShipBuildQueueItem getHeightForTableView:tableView];
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
	
	if (self.shipyard && self.shipyard.buildQueue) {
		if ([self.shipyard.buildQueue count] > 0) {
			ShipBuildQueueItem *currentShip = [self.shipyard.buildQueue objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_SHIP_BUILD_QUEUE_ITEM:
					; //DO NOT REMOVE
					LETableViewCellShipBuildQueueItem *shipBuildQueueCell = [LETableViewCellShipBuildQueueItem getCellForTableView:tableView];
					[shipBuildQueueCell setShipBuildQueueItem:currentShip];
					cell = shipBuildQueueCell;
					break;
				default:
					cell = nil;
					break;
			}
		} else {
			LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			loadingCell.label.text = @"Building";
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
	self.shipyard = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewShipBuildQueueController *)create {
	return [[[ViewShipBuildQueueController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"buildQueue"]) {
		[self.tableView reloadData];
	}
}


@end

