//
//  ViewTravellingShipsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewTravellingShipsController.h"
#import "LEMacros.h"
#import "Util.h"
#import	"SpacePort.h"
#import "TravellingShip.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellTravellingShip.h"


typedef enum {
	ROW_TRAVELLING_SHIP_INFO,
} ROW;


@implementation ViewTravellingShipsController


@synthesize spacePort;
@synthesize lastUpdated;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Ships In Transit";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.spacePort addObserver:self forKeyPath:@"travellingShipsUpdated" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	if (!self.spacePort.travellingShips) {
		[self.spacePort loadTravellingShips];
	} else {
		if (self.lastUpdated) {
			if ([self.lastUpdated compare:self.spacePort.travellingShipsUpdated] == NSOrderedAscending) {
				[self.tableView reloadData];
				self.lastUpdated = self.spacePort.travellingShipsUpdated;
			}
		} else {
			self.lastUpdated = self.spacePort.travellingShipsUpdated;
		}
	}
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.spacePort removeObserver:self forKeyPath:@"travellingShipsUpdated"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.spacePort && self.spacePort.travellingShips) {
		if ([self.spacePort.travellingShips count] > 0) {
			return [self.spacePort.travellingShips count];
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
	if (self.spacePort && self.spacePort.travellingShips) {
		if ([self.spacePort.travellingShips count] > 0) {
			switch (indexPath.row) {
				case ROW_TRAVELLING_SHIP_INFO:
					return [LETableViewCellTravellingShip getHeightForTableView:tableView];
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
	
	if (self.spacePort && self.spacePort.travellingShips) {
		if ([self.spacePort.travellingShips count] > 0) {
			TravellingShip *currentShip = [self.spacePort.travellingShips objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_TRAVELLING_SHIP_INFO:
					; //DO NOT REMOVE
					LETableViewCellTravellingShip *infoCell = [LETableViewCellTravellingShip getCellForTableView:tableView];
					[infoCell setTravellingShip:currentShip];
					cell = infoCell;
					break;
				default:
					cell = nil;
					break;
			}
		} else {
			LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			loadingCell.label.text = @"In Transit";
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
	self.spacePort = nil;
	self.lastUpdated = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewTravellingShipsController *)create {
	return [[[ViewTravellingShipsController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"travellingShipsUpdated"]) {
		[self.tableView reloadData];
		self.lastUpdated = self.spacePort.travellingShipsUpdated;
	}
}


@end

