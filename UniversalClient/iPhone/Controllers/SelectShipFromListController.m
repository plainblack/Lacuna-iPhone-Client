//
//  SelectShipFromListController.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "SelectShipFromListController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Ship.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellShip.h"
#import "LETableViewCellLabeledText.h"


typedef enum {
	ROW_SHIP_INFO,
	ROW_TRAVEL_TIME,
} ROW;


@implementation SelectShipFromListController


@synthesize ships;
@synthesize shipTravelTimes;
@synthesize delegate;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Select Ship";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return MAX([self.ships count], 1);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.shipTravelTimes) {
		return 2;
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.ships count] > 0) {
		switch (indexPath.row) {
			case ROW_SHIP_INFO:
				return [LETableViewCellShip getHeightForTableView:tableView];
				break;
			case ROW_TRAVEL_TIME:
				return [LETableViewCellLabeledText getHeightForTableView:tableView];
				break;
			default:
				return 0.0;
				break;
		}
	} else {
		return [LETableViewCellLabeledText getHeightForTableView:tableView];
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
	
	if ([self.ships count] > 0) {
		Ship *ship = [self.ships objectAtIndex:indexPath.section];
		switch (indexPath.row) {
			case ROW_SHIP_INFO:
				; //DO NOT REMOVE
				LETableViewCellShip *shipCell = [LETableViewCellShip getCellForTableView:self.tableView isSelectable:YES];
				[shipCell setShip:ship];
				cell = shipCell;
				break;
			case ROW_TRAVEL_TIME:
				; //DO NOT REMOVE
				LETableViewCellLabeledText *travelTimeCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				travelTimeCell.label.text = @"Travel Time";
				travelTimeCell.content.text = [Util prettyDuration:_intv([self.shipTravelTimes objectForKey:ship.id])];
				cell = travelTimeCell;
				break;
			default:
				cell = nil;
				break;
		}
	} else {
		LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		emptyCell.label.text = @"Ships";
		emptyCell.content.text = @"None";
		cell = emptyCell;
	}
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.ships count] > 0) {
		Ship *ship = [self.ships objectAtIndex:indexPath.section];
		[self.delegate shipSelected:ship];
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
	self.ships = nil;
	self.shipTravelTimes = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Class Methods

+ (SelectShipFromListController *)create {
	return [[[SelectShipFromListController alloc] init] autorelease];
}


@end

