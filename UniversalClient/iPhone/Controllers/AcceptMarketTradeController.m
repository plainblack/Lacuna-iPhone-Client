//
//  AcceptMarketTradeController.m
//  UniversalClient
//
//  Created by Kevin Runde on 12/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "AcceptMarketTradeController.h"
#import "LEMacros.h"
#import "Util.h"
#import "BaseTradeBuilding.h"
#import "MarketTrade.h"
#import "Ship.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellTextEntry.h"
#import "LETableViewCellLabeledText.h"
#import "LEBuildingAcceptFromMarket.h"
#import "LETableViewCellShip.h"
#import "LETableViewCellButton.h"

typedef enum {
	SECTION_SELECT_SHIP,
	SECTION_ACTION,
} SECTION;

typedef enum {
	ACTION_ROW_ACCEPT,
} ACTION_ROWS;


typedef enum {
	SHIP_ROW_SELECT,
	SHIP_ROW_TRAVEL_TIME,
} SHIP_ROWS;


@implementation AcceptMarketTradeController


@synthesize baseTradeBuilding;
@synthesize trade;
@synthesize sections;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Accept Trade";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Accept" style:UIBarButtonItemStylePlain target:self action:@selector(acceptTrade)] autorelease];
	
	if (self.baseTradeBuilding.selectTradeShip) {
		self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Cargo Ship"], [LEViewSectionTab tableView:self.tableView withText:@"Confirm"]);
		self.sections = _array([NSNumber numberWithInt:SECTION_SELECT_SHIP], [NSNumber numberWithInt:SECTION_ACTION]);
	} else {
		self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Confirm"]);
		self.sections = _array([NSNumber numberWithInt:SECTION_ACTION]);
	}
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
	if (self.baseTradeBuilding.selectTradeShip) {
		return 2;
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (_intv([self.sections objectAtIndex:section])) {
		case SECTION_SELECT_SHIP:
			if (self.trade.tradeShipId) {
				return 2;
			} else {
				return 1;
			}
			break;
		case SECTION_ACTION:
			return 1;
			break;
		default:
			return 0;
			break;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (_intv([self.sections objectAtIndex:indexPath.section])) {
		case SECTION_SELECT_SHIP:
			if (self.trade.tradeShipId) {
				switch (indexPath.row) {
					case SHIP_ROW_SELECT:
						return [LETableViewCellShip getHeightForTableView:tableView];
						break;
					case SHIP_ROW_TRAVEL_TIME:
						return [LETableViewCellLabeledText getHeightForTableView:tableView];
						break;
					default:
						return 0.0;
						break;
				}
			} else {
				return [LETableViewCellButton getHeightForTableView:tableView];
			}
			break;
		case SECTION_ACTION:
			switch (indexPath.row) {
				case ACTION_ROW_ACCEPT:
					return [LETableViewCellButton getHeightForTableView:tableView];
					break;
				default:
					return 0;
					break;
			}
			break;
		default:
			return 0;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
	
	switch (_intv([self.sections objectAtIndex:indexPath.section])) {
		case SECTION_SELECT_SHIP:
			if (self.trade.tradeShipId) {
				switch (indexPath.row) {
					case SHIP_ROW_SELECT:
						; //DO NOT REMOVE
						Ship *tradeShip = [self.baseTradeBuilding.tradeShipsById objectForKey:self.trade.tradeShipId];
						LETableViewCellShip *tradeShipCell = [LETableViewCellShip getCellForTableView:tableView isSelectable:YES];
						[tradeShipCell setShip:tradeShip];
						cell = tradeShipCell;
						break;
					case SHIP_ROW_TRAVEL_TIME:
						; //DO NOT REMOVE
						LETableViewCellLabeledText *travelTimeCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
						travelTimeCell.label.text = @"Travel Time";
						travelTimeCell.content.text = [Util prettyDuration:_intv([self.baseTradeBuilding.tradeShipsTravelTime objectForKey:self.trade.tradeShipId])];
						cell = travelTimeCell;
						break;
					default:
						cell = nil;
						break;
				}
			} else {
				LETableViewCellButton *selectTradeShipButtonCell = [LETableViewCellButton getCellForTableView:tableView];
				selectTradeShipButtonCell.textLabel.text = @"Any Ship With Cargo Space";
				cell = selectTradeShipButtonCell;
			}
			break;
		case SECTION_ACTION:
			switch (indexPath.row) {
				case ACTION_ROW_ACCEPT:
					; //DO NOT REMOVE
					LETableViewCellButton *acceptButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					acceptButtonCell.textLabel.text = @"Accept";
					cell = acceptButtonCell;
					break;
				default:
					cell = nil;
					break;
			}
			break;
		default:
			cell = nil;
			break;
	}
	return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (_intv([self.sections objectAtIndex:indexPath.section])) {
		case SECTION_SELECT_SHIP:
			if (indexPath.row == 0) {
				self->selectTradeShipController = [[SelectTradeShipController create] retain];
				self->selectTradeShipController.delegate = self;
				self->selectTradeShipController.baseTradeBuilding = self.baseTradeBuilding;
				self->selectTradeShipController.targetBodyId = self.trade.bodyId;
				[self.navigationController pushViewController:self->selectTradeShipController animated:YES];
				break;
			}
			break;
		case SECTION_ACTION:
			switch (indexPath.row) {
				case ACTION_ROW_ACCEPT:
					[self acceptTrade];
					break;
				default:
					break;
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
	self.sections = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.baseTradeBuilding = nil;
	self.trade = nil;
	[self->selectTradeShipController release];
	self->selectTradeShipController = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (IBAction)acceptTrade {
	[self.baseTradeBuilding acceptMarketTrade:self.trade target:self callback:@selector(tradeAccepted:)];
}


#pragma mark -
#pragma mark SelectTradeShipController Methods

- (void)tradeShipSelected:(Ship *)ship {
	self.trade.tradeShipId = ship.id;
	[self.navigationController popViewControllerAnimated:YES];
	[self->selectTradeShipController release];
	self->selectTradeShipController = nil;
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Callback Methods

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
		[self.baseTradeBuilding.marketTrades removeObject:self.trade];
		[self.navigationController popViewControllerAnimated:YES];
	}
	
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (AcceptMarketTradeController *)create {
	return [[[AcceptMarketTradeController alloc] init] autorelease];
}


@end

