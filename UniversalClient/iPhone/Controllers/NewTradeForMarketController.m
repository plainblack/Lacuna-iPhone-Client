//
//  NewTradeForMarketController.m
//  UniversalClient
//
//  Created by Kevin Runde on 12/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "NewTradeForMarketController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "BaseTradeBuilding.h"
#import "MarketTrade.h"
#import "Glyph.h"
#import "Plan.h"
#import "Prisoner.h"
#import "Ship.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellParagraph.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellLabeledIconText.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellGlyph.h"
#import "LETableViewCellPlan.h"
#import "LETableViewCellShip.h"
#import "PickColonyController.h"
#import "SelectGlyphController.h"
#import "SelectPlanController.h"
#import "SelectResourceTypeController.h"
#import "SelectStoredResourceController.h"
#import "LEBuildingAddToMarket.h"


#define NOTHING_SELECTED_MESSAGE @"Select something below"

typedef enum {
	SECTION_HAVE,
	SECTION_WANT,
	SECTION_SELECT_SHIP
} SECTIONS;


typedef enum {
	HAVE_ROW_SELECT_GLYPH,
	HAVE_ROW_SELECT_PLAN,
	HAVE_ROW_SELECT_PRISONER,
	HAVE_ROW_SELECT_RESOURCE,
	HAVE_ROW_SELECT_SHIP
} HAVE_ROWS;


typedef enum {
	SHIP_ROW_SELECT,
} SHIP_ROWS;


@interface NewTradeForMarketController (PrivateMethods)

- (void)postTrade;

@end


@implementation NewTradeForMarketController


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
		self.trade = [[[MarketTrade alloc] init] autorelease];
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
            return [self.trade.offer count] + 5;
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
                case HAVE_ROW_SELECT_GLYPH:
                case HAVE_ROW_SELECT_PLAN:
                case HAVE_ROW_SELECT_PRISONER:
                case HAVE_ROW_SELECT_RESOURCE:
                case HAVE_ROW_SELECT_SHIP:
                    return [LETableViewCellButton getHeightForTableView:tableView];
                    break;
                default:
                    ; //DO NOT REMOVE
                    NSMutableDictionary *offerItem = [self.trade.offer objectAtIndex:(indexPath.row - 5)];
                    NSString *offerType = [offerItem objectForKey:@"type"];
                    if ([offerType isEqualToString:@"glyph"]) {
                        return [LETableViewCellGlyph getHeightForTableView:tableView];
                    } else if ([offerType isEqualToString:@"plan"]) {
                        return [LETableViewCellPlan getHeightForTableView:tableView];
                    } else if ([offerType isEqualToString:@"prisoner"]) {
                        return [LETableViewCellLabeledText getHeightForTableView:tableView];
                    } else if ([offerType isEqualToString:@"ship"]) {
                        return [LETableViewCellShip getHeightForTableView:tableView];
                    } else {
                        return [LETableViewCellParagraph getHeightForTableView:tableView text:NOTHING_SELECTED_MESSAGE];
                    }
                    break;
            }
			break;
		case SECTION_WANT:
			return [LETableViewCellLabeledIconText getHeightForTableView:tableView];
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
                case HAVE_ROW_SELECT_GLYPH:
                    ; //DO NOT REMOVE
                    LETableViewCellButton *selectGlyphCell = [LETableViewCellButton getCellForTableView:tableView];
                    selectGlyphCell.textLabel.text = @"Add Glyph";
                    cell = selectGlyphCell;
                    break;
                case HAVE_ROW_SELECT_PLAN:
                    ; //DO NOT REMOVE
                    LETableViewCellButton *selectPlanCell = [LETableViewCellButton getCellForTableView:tableView];
                    selectPlanCell.textLabel.text = @"Add Plan";
                    cell = selectPlanCell;
                    break;
                case HAVE_ROW_SELECT_PRISONER:
                    ; //DO NOT REMOVE
                    LETableViewCellButton *selectPrisonerCell = [LETableViewCellButton getCellForTableView:tableView];
                    selectPrisonerCell.textLabel.text = @"Add Prisoner";
                    cell = selectPrisonerCell;
                    break;
                case HAVE_ROW_SELECT_RESOURCE:
                    ; //DO NOT REMOVE
                    LETableViewCellButton *selectResourceCell = [LETableViewCellButton getCellForTableView:tableView];
                    selectResourceCell.textLabel.text = @"Add Resource";
                    cell = selectResourceCell;
                    break;
                case HAVE_ROW_SELECT_SHIP:
                    ; //DO NOT REMOVE
                    LETableViewCellButton *selectShipCell = [LETableViewCellButton getCellForTableView:tableView];
                    selectShipCell.textLabel.text = @"Add Ship";
                    cell = selectShipCell;
                    break;
                default:
                    ; //DO NOT REMOVE
                    NSMutableDictionary *offerItem = [self.trade.offer objectAtIndex:(indexPath.row - 5)];
                    NSString *offerType = [offerItem objectForKey:@"type"];
                    if (!offerType) {
                        LETableViewCellParagraph *nothingSelectedCell = [LETableViewCellParagraph getCellForTableView:tableView];
                        nothingSelectedCell.content.text = NOTHING_SELECTED_MESSAGE;
                        cell = nothingSelectedCell;
                    } else if ([offerType isEqualToString:@"glyph"]) {
                        Glyph *glyph = [self.baseTradeBuilding.glyphsById objectForKey:[offerItem objectForKey:@"glyph_id"]];
                        LETableViewCellGlyph *glyphCell = [LETableViewCellGlyph getCellForTableView:tableView isSelectable:NO];
                        [glyphCell setGlyph:glyph];
                        cell = glyphCell;
                    } else if ([offerType isEqualToString:@"plan"]) {
                        Plan *plan = [self.baseTradeBuilding.plansById objectForKey:[offerItem objectForKey:@"plan_id"]];
                        LETableViewCellPlan *planCell = [LETableViewCellPlan getCellForTableView:tableView isSelectable:NO];
                        [planCell setPlan:plan];
                        cell = planCell;
                    } else if ([offerType isEqualToString:@"prisoner"]) {
                        Prisoner *prisoner = [self.baseTradeBuilding.prisonersById objectForKey:[offerItem objectForKey:@"prisoner_id"]];
                        LETableViewCellLabeledText *prisonerCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
                        prisonerCell.label.text = [NSString stringWithFormat:@"Level %@", prisoner.level];
                        prisonerCell.content.text = prisoner.name;
                        cell = prisonerCell;
                    } else if ([offerType isEqualToString:@"ship"]) {
                        Ship* ship = [self.baseTradeBuilding.shipsById objectForKey:[offerItem objectForKey:@"ship_id"]];
                        LETableViewCellShip *shipCell = [LETableViewCellShip getCellForTableView:tableView isSelectable:NO];
                        [shipCell setShip:ship];
                        cell = shipCell;
                    } else {
                        NSDecimalNumber *quantity = [Util asNumber:[offerItem objectForKey:@"quantity"]];
                        LETableViewCellLabeledText *itemCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
                        itemCell.label.text = [Util prettyCodeValue:offerType];
                        itemCell.content.text = [Util prettyNSDecimalNumber:quantity];
                        cell = itemCell;
                    }
                    break;
            }
			break;
		case SECTION_WANT:
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
			self->pickNumericValueController = [[PickNumericValueController createWithDelegate:self maxValue:[NSDecimalNumber decimalNumberWithString:@"99"] hidesZero:NO showTenths:YES] retain];
			[self.navigationController pushViewController:self->pickNumericValueController animated:YES];
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


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (_intv([self.sections objectAtIndex:indexPath.section])) {
		case SECTION_HAVE:
            ; //DO NOT REMOVE
            NSMutableDictionary *offerItem = [self.trade.offer objectAtIndex:(indexPath.row - 5)];
            NSString *offerType = [offerItem objectForKey:@"type"];
            if ([offerType isEqualToString:@"glyph"]) {
                [self.baseTradeBuilding.glyphs addObject:[self.baseTradeBuilding.glyphsById objectForKey:[offerItem objectForKey:@"glyph_id"]]];
            } else if ([offerType isEqualToString:@"plan"]) {
                [self.baseTradeBuilding.plans addObject:[self.baseTradeBuilding.plansById objectForKey:[offerItem objectForKey:@"plan_id"]]];
            } else if ([offerType isEqualToString:@"prisoner"]) {
                [self.baseTradeBuilding.prisoners addObject:[self.baseTradeBuilding.prisonersById objectForKey:[offerItem objectForKey:@"prisoner_id"]]];
            } else if ([offerType isEqualToString:@"ship"]) {
                [self.baseTradeBuilding.ships addObject:[self.baseTradeBuilding.shipsById objectForKey:[offerItem objectForKey:@"ship_id"]]];
            } else {
                [self.baseTradeBuilding addTradeableStoredResource:offerItem];
            }
            [self.trade.offer removeObjectAtIndex:(indexPath.row - 5)];
            [tableView deleteRowsAtIndexPaths:_array(indexPath) withRowAnimation:UITableViewRowAnimationTop];
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
    self.sections = nil;
	[self->selectGlyphController release];
	[self->selectPlanController release];
	[self->selectStoredResourceController release];
	[self->selectTradeShipController release];
	[self->pickNumericValueController release];
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (IBAction)post {
	if (self.trade.askEssentia) {
		if (self.baseTradeBuilding.usesEssentia) {
            NSDecimalNumber *cost = [NSDecimalNumber one];
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
#pragma mark SelectGlyphDelegate Methods

- (void)glyphSelected:(Glyph *)glyph {
	[self.trade addGlyph:glyph.id];
	[self.navigationController popViewControllerAnimated:YES];
	[self->selectGlyphController release];
	self->selectGlyphController = nil;
	[self.baseTradeBuilding.glyphs removeObject:glyph];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark SelectPlanDelegate Methods

- (void)planSelected:(Plan *)plan {
	[self.trade addPlan:plan.id];
	[self.navigationController popViewControllerAnimated:YES];
	[self->selectPlanController release];
	self->selectPlanController = nil;
	[self.baseTradeBuilding.plans removeObject:plan];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark SelectTradeablePrisonerController

- (void)prisonerSelected:(Prisoner *)prisoner {
	[self.trade addPrisoner:prisoner.id];
	[self.navigationController popViewControllerAnimated:YES];
	[self->selectTradeablePrisonerController release];
	self->selectTradeablePrisonerController = nil;
	[self.baseTradeBuilding.prisoners removeObject:prisoner];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark SelectTradeableShipControllerDelegate

- (void)shipSelected:(Ship *)ship {
	[self.trade addShip:ship.id];
	[self.navigationController popViewControllerAnimated:YES];
	[self->selectTradeableShipController release];
	self->selectTradeableShipController = nil;
	[self.baseTradeBuilding.ships removeObject:ship];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark SelectStoredResourcesDelegate Methods

- (void)storedResourceSelected:(NSDictionary *)storedResource {
	[self.trade addResource:[storedResource objectForKey:@"type"] amount:[storedResource objectForKey:@"quantity"]];
	[self.navigationController popViewControllerAnimated:YES];
	[self->selectStoredResourceController release];
	self->selectStoredResourceController = nil;
	[self.baseTradeBuilding removeTradeableStoredResource:storedResource];
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

- (id)tradePosted:(LEBuildingAddToMarket *)request {
	if ([request wasError]) {
		NSString *errorText = [request errorMessage];
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Could not post trade." message:errorText preferredStyle:UIAlertControllerStyleAlert];
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

+ (NewTradeForMarketController *)create {
	return [[[NewTradeForMarketController alloc] init] autorelease];
}


@end

