//
//  NewSpyTradeController.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/26/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "NewSpyTradeController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "BaseTradeBuilding.h"
#import "MercenariesGuild.h"
#import "MarketTrade.h"
#import "Spy.h"
#import "Ship.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellShip.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledIconText.h"
#import "LEBuildingAddToSpyMarket.h"


#define NOTHING_SELECTED_MESSAGE @"Select something below"

typedef enum {
	SECTION_HAVE,
	SECTION_WANT,
	SECTION_SELECT_SHIP
} SECTIONS;


typedef enum {
	ROW_SELECT_SPY,
	ROW_SELECT_SHIP,
	ROW_SELECT_AMOUNT,
	ROW_POST,
} HAVE_ROWS;


@interface NewSpyTradeController (PrivateMethods)

- (void)postTrade;

@end


@implementation NewSpyTradeController


@synthesize baseTradeBuilding;
@synthesize trade;
@synthesize rows;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleDone target:self action:@selector(post)] autorelease];
	
    self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"New Trade"]);
	if (self.baseTradeBuilding.selectTradeShip) {
		self.rows = _array([NSNumber numberWithInt:ROW_SELECT_SPY], [NSNumber numberWithInt:ROW_SELECT_SHIP], [NSNumber numberWithInt:ROW_SELECT_AMOUNT], [NSNumber numberWithInt:ROW_POST]);
	} else {
		self.rows = _array([NSNumber numberWithInt:ROW_SELECT_SPY], [NSNumber numberWithInt:ROW_SELECT_AMOUNT], [NSNumber numberWithInt:ROW_POST]);
	}
	
	
	if (!self.trade) {
		self.trade = [[[MarketTrade alloc] init] autorelease];
	}
	[self.baseTradeBuilding clearLoadables];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.rows count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (_intv([self.rows objectAtIndex:indexPath.row])) {
		case ROW_SELECT_SPY:
            if ([self.trade.offer count] > 0) {
                return [LETableViewCellLabeledText getHeightForTableView:tableView];
            } else {
                return [LETableViewCellButton getHeightForTableView:tableView];
            }
            break;
		case ROW_SELECT_SHIP:
			if (self.trade.tradeShipId) {
                return [LETableViewCellShip getHeightForTableView:tableView];
			} else {
				return [LETableViewCellButton getHeightForTableView:tableView];
			}
            break;
		case ROW_SELECT_AMOUNT:
			return [LETableViewCellLabeledIconText getHeightForTableView:tableView];
            break;
		case ROW_POST:
            return [LETableViewCellButton getHeightForTableView:tableView];
            break;
		default:
			return 0;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;

    switch (_intv([self.rows objectAtIndex:indexPath.row])) {
		case ROW_SELECT_SPY:
            if ([self.trade.offer count] > 0) {
                NSMutableDictionary *offerItem = [self.trade.offer objectAtIndex:0];
                Spy *spy = [self.baseTradeBuilding.spiesById objectForKey:[offerItem objectForKey:@"spy_id"]];
                LETableViewCellLabeledText *spyCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:YES];
                spyCell.label.text = [NSString stringWithFormat:@"Level %@", spy.level];
                spyCell.content.text = spy.name;
                cell = spyCell;
            } else {
                LETableViewCellButton *selectGlyphCell = [LETableViewCellButton getCellForTableView:tableView];
                selectGlyphCell.textLabel.text = @"Pick Spy";
                cell = selectGlyphCell;
            }
            break;
		case ROW_SELECT_SHIP:
			if (self.trade.tradeShipId) {
                Ship *tradeShip = [self.baseTradeBuilding.tradeShipsById objectForKey:self.trade.tradeShipId];
                LETableViewCellShip *tradeShipCell = [LETableViewCellShip getCellForTableView:tableView isSelectable:YES];
                [tradeShipCell setShip:tradeShip];
                cell = tradeShipCell;
			} else {
				LETableViewCellButton *selectTradeShipButtonCell = [LETableViewCellButton getCellForTableView:tableView];
				selectTradeShipButtonCell.textLabel.text = @"Any Spy Pod";
				cell = selectTradeShipButtonCell;
			}
            break;
		case ROW_SELECT_AMOUNT:
			; //DO NOT REMOVE
			LETableViewCellLabeledIconText *wantButtonCell = [LETableViewCellLabeledIconText getCellForTableView:tableView isSelectable:YES];
			wantButtonCell.label.text = @"Essentia";
			wantButtonCell.icon.image = ESSENTIA_ICON;
			if (self.trade.askEssentia) {
				wantButtonCell.content.text = [Util prettyNSDecimalNumber:self.trade.askEssentia];
			} else {
				wantButtonCell.content.text = @"0";
			}
			cell = wantButtonCell;
            break;
		case ROW_POST:
			; //DO NOT REMOVE
            LETableViewCellButton *postTradeButtonCell = [LETableViewCellButton getCellForTableView:tableView];
            postTradeButtonCell.textLabel.text = @"Post trade";
            cell = postTradeButtonCell;
            break;
	}

    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (_intv([self.rows objectAtIndex:indexPath.row])) {
		case ROW_SELECT_SPY:
            if ([self.trade.offer count] == 0) {
                self->selectTradeableSpyController = [[SelectTradeableSpyController create] retain];
                self->selectTradeableSpyController.delegate = self;
                self->selectTradeableSpyController.baseTradeBuilding = self.baseTradeBuilding;
                [self.navigationController pushViewController:self->selectTradeableSpyController animated:YES];
            }
            break;
		case ROW_SELECT_SHIP:
            self->selectTradeShipController = [[SelectTradeShipController create] retain];
            self->selectTradeShipController.delegate = self;
            self->selectTradeShipController.baseTradeBuilding = self.baseTradeBuilding;
            [self.navigationController pushViewController:self->selectTradeShipController animated:YES];
            break;
		case ROW_SELECT_AMOUNT:
			; //DO NOT REMOVE
			self->pickNumericValueController = [[PickNumericValueController createWithDelegate:self maxValue:[NSDecimalNumber decimalNumberWithString:@"99"] hidesZero:NO showTenths:YES] retain];
			[self.navigationController pushViewController:self->pickNumericValueController animated:YES];
            break;
		case ROW_POST:
            [self post];
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
	self.rows = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.baseTradeBuilding = nil;
	self.trade = nil;
    self.rows = nil;
	[self->selectTradeShipController release];
	[self->pickNumericValueController release];
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (IBAction)post {
	if (self.trade.askEssentia) {
		if (self.baseTradeBuilding.usesEssentia) {
            NSDecimalNumber *cost = [[NSDecimalNumber decimalNumberWithString:@"3"] decimalNumberBySubtracting:[[NSDecimalNumber decimalNumberWithString:@"0.1"] decimalNumberByMultiplyingBy:self.baseTradeBuilding.level]];
			UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"If this trade is accepted it will cost you %@ Essentia. Do you wish to contine?", cost] message:@"" preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
				[self postTrade];
			}];
			UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
			}];
			[alert addAction:cancelAction];
			[alert addAction:okAction];
			[self presentViewController:alert animated:YES completion:nil];
		} else {
			[self postTrade];
		}
	} else {
		NSString *errorText = @"Invalid Trade";
		if (!self.trade.askEssentia && ([self.trade.offer count] == 0)) {
			errorText = @"You must select what you want to sell and how much you want for it.";
		} else if (!self.trade.askEssentia) {
			errorText = @"You must select how much you want for what you have put up for sale.";
		} else if ([self.trade.offer count] == 0) {
			errorText = @"You must select what you want to sell.";
		}
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Incomplete" message:errorText preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
		
	}
}


#pragma mark -
#pragma mark SelectTradeableSpyController

- (void)spySelected:(Spy *)spy {
	[self.trade addSpy:spy.id];
	[self.navigationController popViewControllerAnimated:YES];
	[self->selectTradeableSpyController release];
	self->selectTradeableSpyController = nil;
	[self.baseTradeBuilding.spies removeObject:spy];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark PickNumericValueControllerDelegate Methods

- (void)newNumericValue:(NSDecimalNumber *)value {
	self.trade.askEssentia = value;
	[self.navigationController popViewControllerAnimated:YES];
	[self->pickNumericValueController release];
	self->pickNumericValueController = nil;
	[self.tableView reloadData];
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
#pragma mark PrivateMethods

- (void)postTrade {
	[self.baseTradeBuilding postMarketTrade:self.trade target:self callback:@selector(tradePosted:)];
}


#pragma mark -
#pragma mark Callbacks

- (id)tradePosted:(LEBuildingAddToSpyMarket *)request {
	if ([request wasError]) {
		NSString *errorText = [request errorMessage];
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Could not post trade" message:errorText preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
		[request markErrorHandled];
	} else {
		[self.navigationController popViewControllerAnimated:YES];
	}
	
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (NewSpyTradeController *)create {
	return [[[NewSpyTradeController alloc] init] autorelease];
}


@end
