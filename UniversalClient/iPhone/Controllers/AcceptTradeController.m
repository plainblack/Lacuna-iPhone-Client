//
//  AcceptTradeController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/22/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "AcceptTradeController.h"
#import "LEMacros.h"
#import "Util.h"
#import "BaseTradeBuilding.h"
#import "Trade.h"
#import "Ship.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellTextEntry.h"
#import "LETableViewCellLabeledText.h"
#import "LEBuildingAcceptTrade.h"
#import "LETableViewCellCaptchaImage.h"
#import "LETableViewCellShip.h"
#import "LETableViewCellButton.h"

typedef enum {
	SECTION_SELECT_SHIP,
	SECTION_CAPTCHA
} SECTION;

typedef enum {
	ROW_CAPTCHA_IMAGE,
	ROW_CAPTCHA_SOLUTION
} ROWS;


typedef enum {
	SHIP_ROW_SELECT,
	SHIP_ROW_TRAVEL_TIME,
} SHIP_ROWS;


@implementation AcceptTradeController


@synthesize baseTradeBuilding;
@synthesize trade;
@synthesize answerCell;
@synthesize sections;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Accept Trade";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(acceptTrade)] autorelease];
	
	if (self.baseTradeBuilding.selectTradeShip) {
		self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Cargo Ship"], [LEViewSectionTab tableView:self.tableView withText:@"Confirm"]);
		self.sections = _array([NSNumber numberWithInt:SECTION_SELECT_SHIP], [NSNumber numberWithInt:SECTION_CAPTCHA]);
	} else {
		self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Confirm"]);
		self.sections = _array([NSNumber numberWithInt:SECTION_CAPTCHA]);
	}
	
	
	self.answerCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.answerCell.label.text = @"Answer";
	self.answerCell.returnKeyType = UIReturnKeySend;
	self.answerCell.delegate = self;
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
		case SECTION_CAPTCHA:
			return 2;
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
		case SECTION_CAPTCHA:
			switch (indexPath.row) {
				case ROW_CAPTCHA_IMAGE:
					return [LETableViewCellCaptchaImage getHeightForTableView:tableView];
					break;
				case ROW_CAPTCHA_SOLUTION:
					return [LETableViewCellTextEntry getHeightForTableView:tableView];
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
		case SECTION_CAPTCHA:
			switch (indexPath.row) {
				case ROW_CAPTCHA_IMAGE:
					; //DO NOT REMOVE
					LETableViewCellCaptchaImage *captchaImageCell = [LETableViewCellCaptchaImage getCellForTableView:tableView];
					[captchaImageCell setCapthchaImageURL:self.baseTradeBuilding.captchaUrl];
					cell = captchaImageCell;
					break;
				case ROW_CAPTCHA_SOLUTION:
					; //DO NOT REMOVE
					cell = self.answerCell;
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
	self.answerCell = nil;
	[self->selectTradeShipController release];
	self->selectTradeShipController = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark UITextFieldDelegate methods


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.answerCell.textField) {
		[self acceptTrade];
	}
	
	return YES;
}


#pragma mark -
#pragma mark Instance Methods

- (IBAction)acceptTrade {
	[self.baseTradeBuilding acceptTrade:self.trade solution:self.answerCell.textField.text target:self callback:@selector(tradeAccepted:)];
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

- (id)tradeAccepted:(LEBuildingAcceptTrade *)request {
	if ([request wasError]) {
		NSString *errorText = [request errorMessage];
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Could not accept trade." message:errorText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[av show];

		switch ([request errorCode]) {
			case 1014:
				; //DO NOT REMOVE
				self.baseTradeBuilding.captchaUrl = [[request errorData] objectForKey:@"url"];
				self.baseTradeBuilding.captchaGuid = [[request errorData] objectForKey:@"guid"];
				break;
		}
		[request markErrorHandled];
		[self.tableView reloadData];

	} else {
		[self.baseTradeBuilding.availableTrades removeObject:self.trade];
		[self.navigationController popViewControllerAnimated:YES];
	}
	
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (AcceptTradeController *)create {
	return [[[AcceptTradeController alloc] init] autorelease];
}


@end

