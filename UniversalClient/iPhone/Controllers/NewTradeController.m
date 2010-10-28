//
//  NewTradeController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/22/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "NewTradeController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "BaseTradeBuilding.h"
#import "Trade.h"
#import "Glyph.h"
#import "Plan.h"
#import "Prisoner.h"
#import "Ship.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellGlyph.h"
#import "LETableViewCellPlan.h"
#import "LETableViewCellShip.h"
#import "PickColonyController.h"
#import "SelectGlyphController.h"
#import "SelectPlanController.h"
#import "SelectResourceTypeController.h"
#import "SelectStoredResourceController.h"
#import "LEBuildingAddTrade.h"


typedef enum {
	SECTION_HAVE,
	SECTION_WANT,
	SECTION_SELECT_SHIP
} SECTIONS;


typedef enum {
	HAVE_ROW_SELECTED_ITEM,
	HAVE_ROW_SELECT_GLYPH,
	HAVE_ROW_SELECT_PLAN,
	HAVE_ROW_SELECT_PRISONER,
	HAVE_ROW_SELECT_RESOURCE,
	HAVE_ROW_SELECT_SHIP
} HAVE_ROWS;


typedef enum {
	SHIP_ROW_SELECT,
} SHIP_ROWS;


@interface NewTradeController (PrivateMethods)

- (void)postTrade;
- (void)clearExistingOffer;

@end


@implementation NewTradeController


@synthesize baseTradeBuilding;
@synthesize trade;
@synthesize sections;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleDone target:self action:@selector(post)] autorelease];

	if (self.baseTradeBuilding.selectTradeShip) {
		self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Have"], [LEViewSectionTab tableView:self.tableView withText:@"Want"], [LEViewSectionTab tableView:self.tableView withText:@"Trade Ship"]);
		self.sections = _array([NSNumber numberWithInt:SECTION_HAVE], [NSNumber numberWithInt:SECTION_WANT], [NSNumber numberWithInt:SECTION_SELECT_SHIP]);
	} else {
		self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Have"], [LEViewSectionTab tableView:self.tableView withText:@"Want"]);
		self.sections = _array([NSNumber numberWithInt:SECTION_HAVE], [NSNumber numberWithInt:SECTION_WANT]);
	}
	
	
	if (!self.trade) {
		self.trade = [[[Trade alloc] init] autorelease];
	}
	[self.baseTradeBuilding clearLoadables];
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
		return 3;
	} else {
		return 2;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (_intv([self.sections objectAtIndex:section])) {
		case SECTION_HAVE:
			return 6;
			break;
		case SECTION_WANT:
			return 1;
			break;
		case SECTION_SELECT_SHIP:
			if (self.trade.tradeShipId) {
				return 1;
			} else {
				return 1;
			}
			break;
		default:
			return 0;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (_intv([self.sections objectAtIndex:indexPath.section])) {
		case SECTION_HAVE:
			switch (indexPath.row) {
				case HAVE_ROW_SELECTED_ITEM:
					if (!self.trade.offerType) {
						return [LETableViewCellLabeledText getHeightForTableView:tableView];
					} else if ([self.trade.offerType isEqualToString:@"glyph"]) {
						return [LETableViewCellGlyph getHeightForTableView:tableView];
					} else if ([self.trade.offerType isEqualToString:@"plan"]) {
						return [LETableViewCellPlan getHeightForTableView:tableView];
					} else if ([self.trade.offerType isEqualToString:@"prisoner"]) {
						return [LETableViewCellLabeledText getHeightForTableView:tableView];
					} else if ([self.trade.offerType isEqualToString:@"ship"]) {
						return [LETableViewCellShip getHeightForTableView:tableView];
					} else {
						return [LETableViewCellLabeledText getHeightForTableView:tableView];
					}
					break;
				case HAVE_ROW_SELECT_GLYPH:
				case HAVE_ROW_SELECT_PLAN:
				case HAVE_ROW_SELECT_PRISONER:
				case HAVE_ROW_SELECT_RESOURCE:
				case HAVE_ROW_SELECT_SHIP:
					return [LETableViewCellButton getHeightForTableView:tableView];
					break;
				default:
					return 0;
					break;
			}
			break;
		case SECTION_WANT:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case SECTION_SELECT_SHIP:
			if (self.trade.tradeShipId) {
				switch (indexPath.row) {
					case SHIP_ROW_SELECT:
						return [LETableViewCellShip getHeightForTableView:tableView];
						break;
					default:
						return 0.0;
						break;
				}
			} else {
				return [LETableViewCellButton getHeightForTableView:tableView];
			}
			break;
		default:
			return 0;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
	
	switch (_intv([self.sections objectAtIndex:indexPath.section])) {
		case SECTION_HAVE:
			switch (indexPath.row) {
				case HAVE_ROW_SELECTED_ITEM:
					if (!self.trade.offerType) {
						LETableViewCellLabeledText *itemCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
						itemCell.label.text = @"None";
						itemCell.content.text = @"Select something below";
						cell = itemCell;
					} else if ([self.trade.offerType isEqualToString:@"glyph"]) {
						Glyph *glyph = [self.baseTradeBuilding.glyphsById objectForKey:self.trade.offerGlyphId];
						LETableViewCellGlyph *glyphCell = [LETableViewCellGlyph getCellForTableView:tableView isSelectable:NO];
						[glyphCell setGlyph:glyph];
						cell = glyphCell;
					} else if ([self.trade.offerType isEqualToString:@"plan"]) {
						Plan *plan = [self.baseTradeBuilding.plansById objectForKey:self.trade.offerPlanId];
						LETableViewCellPlan *planCell = [LETableViewCellPlan getCellForTableView:tableView isSelectable:NO];
						[planCell setPlan:plan];
						cell = planCell;
					} else if ([self.trade.offerType isEqualToString:@"prisoner"]) {
						Prisoner *prisoner = [self.baseTradeBuilding.prisonersById objectForKey:self.trade.offerPrisonerId];
						LETableViewCellLabeledText *prisonerCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
						prisonerCell.label.text = [NSString stringWithFormat:@"Level %@", prisoner.level];
						prisonerCell.content.text = prisoner.name;
						cell = prisonerCell;
					} else if ([self.trade.offerType isEqualToString:@"ship"]) {
						Ship* ship = [self.baseTradeBuilding.shipsById objectForKey:self.trade.offerShipId];
						LETableViewCellShip *shipCell = [LETableViewCellShip getCellForTableView:tableView isSelectable:NO];
						[shipCell setShip:ship];
						cell = shipCell;
					} else {
						LETableViewCellLabeledText *itemCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
						itemCell.label.text = [self.trade.offerType capitalizedString];
						itemCell.content.text = [Util prettyNSDecimalNumber:self.trade.offerQuantity];
						cell = itemCell;
					}
					break;
				case HAVE_ROW_SELECT_GLYPH:
					; //DO NOT REMOVE
					LETableViewCellButton *selectGlyphCell = [LETableViewCellButton getCellForTableView:tableView];
					selectGlyphCell.textLabel.text = @"Select Glyph";
					cell = selectGlyphCell;
					break;
				case HAVE_ROW_SELECT_PLAN:
					; //DO NOT REMOVE
					LETableViewCellButton *selectPlanCell = [LETableViewCellButton getCellForTableView:tableView];
					selectPlanCell.textLabel.text = @"Select Plan";
					cell = selectPlanCell;
					break;
				case HAVE_ROW_SELECT_PRISONER:
					; //DO NOT REMOVE
					LETableViewCellButton *selectPrisonerCell = [LETableViewCellButton getCellForTableView:tableView];
					selectPrisonerCell.textLabel.text = @"Select Prisoner";
					cell = selectPrisonerCell;
					break;
				case HAVE_ROW_SELECT_RESOURCE:
					; //DO NOT REMOVE
					LETableViewCellButton *selectResourceCell = [LETableViewCellButton getCellForTableView:tableView];
					selectResourceCell.textLabel.text = @"Select Resource";
					cell = selectResourceCell;
					break;
				case HAVE_ROW_SELECT_SHIP:
					; //DO NOT REMOVE
					LETableViewCellButton *selectShipCell = [LETableViewCellButton getCellForTableView:tableView];
					selectShipCell.textLabel.text = @"Select Ship";
					cell = selectShipCell;
					break;
			}
			break;
		case SECTION_WANT:
			; //DO NOT REMOVE
			LETableViewCellButton *wantButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			if (self.trade.askType) {
				wantButtonCell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", [self.trade.askType capitalizedString], [Util prettyNSDecimalNumber:self.trade.askQuantity]];
			} else {
				wantButtonCell.textLabel.text = @"Select Resource Type";
			}
			cell = wantButtonCell;
			break;
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
	}

    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (_intv([self.sections objectAtIndex:indexPath.section])) {
		case SECTION_HAVE:
			switch (indexPath.row) {
				case HAVE_ROW_SELECT_GLYPH:
					; //DO NOT REMOVE
					self->selectGlyphController = [[SelectGlyphController create] retain];
					self->selectGlyphController.delegate = self;
					self->selectGlyphController.baseTradeBuilding = self.baseTradeBuilding;
					[self.navigationController pushViewController:self->selectGlyphController animated:YES];
					break;
				case HAVE_ROW_SELECT_PLAN:
					; //DO NOT REMOVE
					self->selectPlanController = [[SelectPlanController create] retain];
					self->selectPlanController.delegate = self;
					self->selectPlanController.baseTradeBuilding = self.baseTradeBuilding;
					[self.navigationController pushViewController:self->selectPlanController animated:YES];
					break;
				case HAVE_ROW_SELECT_PRISONER:
					; //DO NOT REMOVE
					self->selectTradeablePrisonerController = [[SelectTradeablePrisonerController create] retain];
					self->selectTradeablePrisonerController.delegate = self;
					self->selectTradeablePrisonerController.baseTradeBuilding = self.baseTradeBuilding;
					[self.navigationController pushViewController:self->selectTradeablePrisonerController animated:YES];
					break;
				case HAVE_ROW_SELECT_RESOURCE:
					; //DO NOT REMOVE
					self->selectStoredResourceController = [[SelectStoredResourceController create] retain];
					self->selectStoredResourceController.delegate = self;
					self->selectStoredResourceController.baseTradeBuilding = self.baseTradeBuilding;
					[self.navigationController pushViewController:self->selectStoredResourceController animated:YES];
					break;
				case HAVE_ROW_SELECT_SHIP:
					; //DO NOT REMOVE
					self->selectTradeableShipController = [[SelectTradeableShipController create] retain];
					self->selectTradeableShipController.delegate = self;
					self->selectTradeableShipController.baseTradeBuilding = self.baseTradeBuilding;
					[self.navigationController pushViewController:self->selectTradeableShipController animated:YES];
					break;
			}
			break;
		case SECTION_WANT:
			; //DO NOT REMOVE
			self->selectResourceTypeController = [[SelectResourceTypeController create] retain];
			self->selectResourceTypeController.includeQuantity = YES;
			self->selectResourceTypeController.delegate = self;
			self->selectResourceTypeController.baseTradeBuilding = self.baseTradeBuilding;
			[self.navigationController pushViewController:self->selectResourceTypeController animated:YES];
			break;
		case SECTION_SELECT_SHIP:
			if (indexPath.row == 0) {
				self->selectTradeShipController = [[SelectTradeShipController create] retain];
				self->selectTradeShipController.delegate = self;
				self->selectTradeShipController.baseTradeBuilding = self.baseTradeBuilding;
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
	[self->selectGlyphController release];
	[self->selectPlanController release];
	[self->selectResourceTypeController release];
	[self->selectStoredResourceController release];
	[self->selectTradeShipController release];
	self->selectTradeShipController = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (IBAction)post {
	if (self.trade.askType && self.trade.askType) {
		if (self.baseTradeBuilding.usesEssentia) {
			UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"If this trade is accepted it will cost you 1 Essentia. Do you wish to contine?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
			actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
			[actionSheet showFromTabBar:self.tabBarController.tabBar];
			[actionSheet release];
		} else {
			[self postTrade];
		}
	} else {
		NSString *errorText = @"Invalid Trade";
		if (!self.trade.askType && !self.trade.offerType) {
			errorText = @"You must select what you have to trade and want to receive.";
		} else if (!self.trade.offerType) {
			errorText = @"You must select what you have to trade.";
		} else if (!self.trade.askType) {
			errorText = @"You must select what you want to receive.";
		}
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Incomplete" message:errorText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[av show];

	}
}


#pragma mark -
#pragma mark SelectGlyphDelegate Methods

- (void)glyphSelected:(Glyph *)glyph {
	[self clearExistingOffer];
	self.trade.offerType = @"glyph";
	self.trade.offerGlyphId = glyph.id;
	[self.navigationController popViewControllerAnimated:YES];
	[self->selectGlyphController release];
	self->selectGlyphController = nil;
	[self.baseTradeBuilding.glyphs removeObject:glyph];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark SelectPlanDelegate Methods

- (void)planSelected:(Plan *)plan {
	[self clearExistingOffer];
	self.trade.offerType = @"plan";
	self.trade.offerPlanId = plan.id;
	[self.navigationController popViewControllerAnimated:YES];
	[self->selectPlanController release];
	self->selectPlanController = nil;
	[self.baseTradeBuilding.plans removeObject:plan];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark SelectTradeablePrisonerController

- (void)prisonerSelected:(Prisoner *)prisoner {
	[self clearExistingOffer];
	self.trade.offerType = @"prisoner";
	self.trade.offerPrisonerId = prisoner.id;
	[self.navigationController popViewControllerAnimated:YES];
	[self->selectTradeablePrisonerController release];
	self->selectTradeablePrisonerController = nil;
	[self.baseTradeBuilding.prisoners removeObject:prisoner];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark SelectTradeableShipControllerDelegate

- (void)shipSelected:(Ship *)ship {
	[self clearExistingOffer];
	self.trade.offerType = @"ship";
	self.trade.offerShipId = ship.id;
	[self.navigationController popViewControllerAnimated:YES];
	[self->selectTradeableShipController release];
	self->selectTradeableShipController = nil;
	[self.baseTradeBuilding.ships removeObject:ship];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark SelectStoredResourcesDelegate Methods

- (void)storedResourceSelected:(NSDictionary *)storedResource {
	[self clearExistingOffer];
	self.trade.offerType = [storedResource objectForKey:@"type"];
	self.trade.offerQuantity = [storedResource objectForKey:@"quantity"];
	[self.navigationController popViewControllerAnimated:YES];
	[self->selectStoredResourceController release];
	self->selectStoredResourceController = nil;
	[self.baseTradeBuilding removeTradeableStoredResource:storedResource];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark SelectStoredResourcesDelegate Methods

- (void)resourceTypeSelected:(NSString *)resourceType withQuantity:(NSDecimalNumber *)quantity {
	self.trade.askType = resourceType;
	self.trade.askQuantity = quantity;
	[self.navigationController popViewControllerAnimated:YES];
	[self->selectResourceTypeController release];
	self->selectResourceTypeController = nil;
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
	[self.baseTradeBuilding postTrade:self.trade target:self callback:@selector(tradePosted:)];
}


- (void)clearExistingOffer {
	if (self.trade.offerType) {
		if ([self.trade.offerType isEqualToString:@"glyph"]) {
			[self.baseTradeBuilding.glyphs addObject:[self.baseTradeBuilding.glyphsById objectForKey:self.trade.offerGlyphId]];
			self.trade.offerGlyphId = nil;
		} else if ([self.trade.offerType isEqualToString:@"plan"]) {
			[self.baseTradeBuilding.plans addObject:[self.baseTradeBuilding.plansById objectForKey:self.trade.offerPlanId]];
			self.trade.offerPlanId = nil;
		} else if ([self.trade.offerType isEqualToString:@"prisoner"]) {
			[self.baseTradeBuilding.prisoners addObject:[self.baseTradeBuilding.plansById objectForKey:self.trade.offerPrisonerId]];
			self.trade.offerPrisonerId = nil;
		} else if ([self.trade.offerType isEqualToString:@"ship"]) {
			[self.baseTradeBuilding.ships addObject:[self.baseTradeBuilding.plansById objectForKey:self.trade.offerShipId]];
			self.trade.offerShipId = nil;
		} else {
			[self.baseTradeBuilding addTradeableStoredResource:_dict(self.trade.offerType, @"type", self.trade.offerQuantity, @"quantity")];
			self.trade.offerQuantity = nil;
		}
		self.trade.offerType = nil;
	}
}


#pragma mark -
#pragma mark Callbacks

- (id)tradePosted:(LEBuildingAddTrade *)request {
	if ([request wasError]) {
		NSString *errorText = [request errorMessage];
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Could not post trade." message:errorText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[av show];
		[request markErrorHandled];
	} else {
		[self.navigationController popViewControllerAnimated:YES];
	}
	
	return nil;
}

#pragma mark -
#pragma mark UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.destructiveButtonIndex == buttonIndex ) {
		[self postTrade];
	}
}


#pragma mark -
#pragma mark Class Methods

+ (NewTradeController *)create {
	return [[[NewTradeController alloc] init] autorelease];
}


@end

