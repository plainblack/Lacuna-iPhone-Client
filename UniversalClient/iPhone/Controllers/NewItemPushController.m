//
//  NewItemPushController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "NewItemPushController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "BaseTradeBuilding.h"
#import "ItemPush.h"
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
#import "SelectStoredResourceController.h"
#import "LEBuildingPushItems.h"


typedef enum {
	SECTION_PUSH_TO,
	SECTION_ITEMS,
	SECTION_ADD
} SECTIONS;


typedef enum {
	ADD_ROW_TOTAL,
	ADD_ROW_GLYPH,
	ADD_ROW_PLAN,
	ADD_ROW_PRISONER,
	ADD_ROW_RESOURCE,
	ADD_ROW_SHIP,
} ADD_ROWS;


@interface NewItemPushController (PrivateMethods)

- (void)showColonyPicker;
- (void)pushItems;

@end


@implementation NewItemPushController


@synthesize baseTradeBuilding;
@synthesize itemPush;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(send)] autorelease];
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Push To"], [LEViewSectionTab tableView:self.tableView withText:@"Items To Push"], [LEViewSectionTab tableView:self.tableView withText:@"Add"]);
	
	if (!self.itemPush) {
		self.itemPush = [[[ItemPush alloc] init] autorelease];
	}
	[self.baseTradeBuilding clearLoadables];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	if (!self.itemPush.targetId) {
		Session *session = [Session sharedInstance];
		if	([session.empire.planets count] == 2) {
			if ([[[session.empire.planets objectAtIndex:0] objectForKey:@"id"] isEqualToString:session.body.id]) {
				self.itemPush.targetId = [[session.empire.planets objectAtIndex:1] objectForKey:@"id"];
			} else {
				self.itemPush.targetId = [[session.empire.planets objectAtIndex:0] objectForKey:@"id"];
			}
		} else {
			[self showColonyPicker];
		}
	}
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
	return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case SECTION_PUSH_TO:
			return 1;
			break;
		case SECTION_ITEMS:
			; //DO NOT REMOVE
			NSInteger count = [self.itemPush.items count];
			if (count > 0) {
				return count;
			} else {
				return 1;
			}
			break;
		case SECTION_ADD:
			return 6;
			break;
		default:
			return 0;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_PUSH_TO:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case SECTION_ITEMS:
			; //DO NOT REMOVE
			NSInteger count = [self.itemPush.items count];
			if (count > 0) {
				NSMutableDictionary *item = [self.itemPush.items objectAtIndex:indexPath.row];
				NSString *type = [item objectForKey:@"type"];
				if ([type isEqualToString:@"glyph"]) {
					return [LETableViewCellGlyph getHeightForTableView:tableView];
				} else if ([type isEqualToString:@"plan"]) {
					return [LETableViewCellPlan getHeightForTableView:tableView];
				} else if ([type isEqualToString:@"prisoner"]) {
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
				} else if ([type isEqualToString:@"ship"]) {
					return [LETableViewCellShip getHeightForTableView:tableView];
				} else {
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
				}
			} else {
				return [LETableViewCellLabeledText getHeightForTableView:tableView];
			}
			break;
		case SECTION_ADD:
			if (indexPath.row == ADD_ROW_TOTAL) {
				return [LETableViewCellLabeledText getHeightForTableView:tableView];
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
    
    UITableViewCell *cell;

	switch (indexPath.section) {
		case SECTION_PUSH_TO:
			; //DO NOT REMOVE
			LETableViewCellButton *selectColonyButton = [LETableViewCellButton getCellForTableView:tableView];
			if (self.itemPush.targetId) {
				Session *session = [Session sharedInstance];
				[session.empire.planets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
					NSLog(@"TEST ID", [obj objectForKey:@"id"]);
					NSLog(@"TARGET ID", self.itemPush.targetId);
					if ([[obj objectForKey:@"id"] isEqualToString:self.itemPush.targetId]) {
						selectColonyButton.textLabel.text = [obj objectForKey:@"name"];
						*stop = YES;
					}
				}];
			} else {
				selectColonyButton.textLabel.text = @"Select Colony";
			}
			cell = selectColonyButton;
			break;
		case SECTION_ITEMS:
			; //DO NOT REMOVE
			NSInteger count = [self.itemPush.items count];
			if (count > 0) {
				NSMutableDictionary *item = [self.itemPush.items objectAtIndex:indexPath.row];
				NSString *type = [item objectForKey:@"type"];
				if ([type isEqualToString:@"glyph"]) {
					Glyph *glyph = [self.baseTradeBuilding.glyphsById objectForKey:[item objectForKey:@"glyph_id"]];
					LETableViewCellGlyph *glyphCell = [LETableViewCellGlyph getCellForTableView:tableView isSelectable:NO];
					[glyphCell setGlyph:glyph];
					cell = glyphCell;
				} else if ([type isEqualToString:@"plan"]) {
					Plan *plan = [self.baseTradeBuilding.plansById objectForKey:[item objectForKey:@"plan_id"]];
					LETableViewCellPlan *planCell = [LETableViewCellPlan getCellForTableView:tableView isSelectable:NO];
					[planCell setPlan:plan];
					cell = planCell;
				} else if ([type isEqualToString:@"prisoner"]) {
					Prisoner *prisoner = [self.baseTradeBuilding.prisonersById objectForKey:[item objectForKey:@"prisoner_id"]];
					LETableViewCellLabeledText *prisonerCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					prisonerCell.label.text = [NSString stringWithFormat:@"Level %@", prisoner.level];
					prisonerCell.content.text = prisoner.name;
					cell = prisonerCell;
				} else if ([type isEqualToString:@"ship"]) {
					Ship *ship = [self.baseTradeBuilding.shipsById objectForKey:[item objectForKey:@"ship_id"]];
					LETableViewCellShip *shipCell = [LETableViewCellShip getCellForTableView:tableView isSelectable:NO];
					[shipCell setShip:ship];
					cell = shipCell;
				} else {
					LETableViewCellLabeledText *itemCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					itemCell.label.text = [type capitalizedString];
					itemCell.content.text = [Util prettyNSDecimalNumber:[item objectForKey:@"quantity"]];
					cell = itemCell;
				}
			} else {
				LETableViewCellLabeledText *noItemsCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				noItemsCell.label.text = @"None yet";
				noItemsCell.content.text = @"Go add some!";
				cell = noItemsCell;
			}
			break;
		case SECTION_ADD:
			switch (indexPath.row) {
				case ADD_ROW_TOTAL:
					; //DO NOT REMOVE
					NSInteger numGlyphs = 0;
					NSInteger numPlans = 0;
					NSInteger numPrisoners = 0;
					NSInteger numShips = 0;
					NSDecimalNumber *numStoredResources = [NSDecimalNumber zero];
					
					for (NSDictionary *item in self.itemPush.items) {
						NSString *type = [item objectForKey:@"type"];
						if ([type isEqualToString:@"glyph"]) {
							numGlyphs++;
						} else if ([type isEqualToString:@"plan"]) {
							numPlans++;
						} else if ([type isEqualToString:@"prisoner"]) {
							numPrisoners++;
						} else if ([type isEqualToString:@"ship"]) {
							numShips++;
						} else {
							numStoredResources = [numStoredResources decimalNumberByAdding:[item objectForKey:@"quantity"]];
						}
					}
					NSDecimalNumber *total = [self.baseTradeBuilding calculateStorageForGlyphs:numGlyphs plans:numPlans prisoners:numPrisoners storedResources:numStoredResources ships:numShips];
					LETableViewCellLabeledText *totalCargoCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					totalCargoCell.label.text = @"Cargo Size";
					if (self.baseTradeBuilding.maxCargoSize) {
						totalCargoCell.content.text =[NSString stringWithFormat:@"%@ / %@", [Util prettyNSDecimalNumber:total], [Util prettyNSDecimalNumber:self.baseTradeBuilding.maxCargoSize]];
					} else {
						totalCargoCell.content.text =[total stringValue];
					}
					cell = totalCargoCell;
					break;
				case ADD_ROW_GLYPH:
					; //DO NOT REMOVE
					LETableViewCellButton *addGlyphButton = [LETableViewCellButton getCellForTableView:tableView];
					addGlyphButton.textLabel.text = @"Add Glyph";
					cell = addGlyphButton;
					break;
				case ADD_ROW_PLAN:
					; //DO NOT REMOVE
					LETableViewCellButton *addPlanButton = [LETableViewCellButton getCellForTableView:tableView];
					addPlanButton.textLabel.text = @"Add Plan";
					cell = addPlanButton;
					break;
				case ADD_ROW_PRISONER:
					; //DO NOT REMOVE
					LETableViewCellButton *addPrisonerButton = [LETableViewCellButton getCellForTableView:tableView];
					addPrisonerButton.textLabel.text = @"Add Prisoner";
					cell = addPrisonerButton;
					break;
				case ADD_ROW_RESOURCE:
					; //DO NOT REMOVE
					LETableViewCellButton *addResourceButton = [LETableViewCellButton getCellForTableView:tableView];
					addResourceButton.textLabel.text = @"Add Resource";
					cell = addResourceButton;
					break;
				case ADD_ROW_SHIP:
					; //DO NOT REMOVE
					LETableViewCellButton *addShipButton = [LETableViewCellButton getCellForTableView:tableView];
					addShipButton.textLabel.text = @"Add Ship";
					cell = addShipButton;
					break;
			}
			break;
	}
	
    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_PUSH_TO:
			[self showColonyPicker];
			break;
		case SECTION_ADD:
			switch (indexPath.row) {
				case ADD_ROW_GLYPH:
					; //DO NOT REMOVE
					self->selectGlyphController = [[SelectGlyphController create] retain];
					self->selectGlyphController.delegate = self;
					self->selectGlyphController.baseTradeBuilding = self.baseTradeBuilding;
					[self.navigationController pushViewController:self->selectGlyphController animated:YES];
					break;
				case ADD_ROW_PLAN:
					; //DO NOT REMOVE
					self->selectPlanController = [[SelectPlanController create] retain];
					self->selectPlanController.delegate = self;
					self->selectPlanController.baseTradeBuilding = self.baseTradeBuilding;
					[self.navigationController pushViewController:self->selectPlanController animated:YES];
					break;
				case ADD_ROW_PRISONER:
					; //DO NOT REMOVE
					self->selectTradeablePrisonerController = [[SelectTradeablePrisonerController create] retain];
					self->selectTradeablePrisonerController.delegate = self;
					self->selectTradeablePrisonerController.baseTradeBuilding = self.baseTradeBuilding;
					[self.navigationController pushViewController:self->selectTradeablePrisonerController animated:YES];
					break;
				case ADD_ROW_RESOURCE:
					; //DO NOT REMOVE
					self->selectStoredResourceController = [[SelectStoredResourceController create] retain];
					self->selectStoredResourceController.delegate = self;
					self->selectStoredResourceController.baseTradeBuilding = self.baseTradeBuilding;
					[self.navigationController pushViewController:self->selectStoredResourceController animated:YES];
					break;
				case ADD_ROW_SHIP:
					; //DO NOT REMOVE
					self->selectTradeableShipController = [[SelectTradeableShipController create] retain];
					self->selectTradeableShipController.delegate = self;
					self->selectTradeableShipController.baseTradeBuilding = self.baseTradeBuilding;
					[self.navigationController pushViewController:self->selectTradeableShipController animated:YES];
					break;
			}
			break;
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_PUSH_TO:
			return NO;
			break;
		case SECTION_ITEMS:
			; //DO NOT REMOVE
			NSInteger count = [self.itemPush.items count];
			if (count > 0) {
				return YES;
			} else {
				return NO;
			}
			break;
		case SECTION_ADD:
			return NO;
			break;
		default:
			return NO;
	}
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ( (indexPath.section == SECTION_ITEMS) && (editingStyle == UITableViewCellEditingStyleDelete) ) {
		NSMutableDictionary *item = [self.itemPush.items objectAtIndex:indexPath.row];
		NSString *type = [item objectForKey:@"type"];
		if ([type isEqualToString:@"glyph"]) {
			[self.baseTradeBuilding.glyphs addObject:[self.baseTradeBuilding.glyphsById objectForKey:[item objectForKey:@"glyph_id"]]];
		} else if ([type isEqualToString:@"plan"]) {
			[self.baseTradeBuilding.plans addObject:[self.baseTradeBuilding.plansById objectForKey:[item objectForKey:@"plan_id"]]];
		} else if ([type isEqualToString:@"prisoner"]) {
			[self.baseTradeBuilding.prisoners addObject:[self.baseTradeBuilding.prisonersById objectForKey:[item objectForKey:@"prisoner_id"]]];
		} else if ([type isEqualToString:@"ship"]) {
			[self.baseTradeBuilding.ships addObject:[self.baseTradeBuilding.shipsById objectForKey:[item objectForKey:@"ship_id"]]];
		} else {
			[self.baseTradeBuilding addTradeableStoredResource:item];
		}
		[self.itemPush.items removeObjectAtIndex:indexPath.row];
		[self.tableView reloadData];
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
	self.baseTradeBuilding = nil;
	self.itemPush = nil;
	[self->pickColonyController release];
	self->pickColonyController = nil;
	[self->selectGlyphController release];
	self->selectGlyphController = nil;
	[self->selectPlanController release];
	self->selectPlanController = nil;
	[self->selectTradeablePrisonerController release];
	self->selectTradeablePrisonerController = nil;
	[self->selectStoredResourceController release];
	self->selectStoredResourceController = nil;
	[self->selectTradeableShipController release];
	self->selectTradeableShipController = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (IBAction)send {
	if ([self.itemPush.items count] == 0) {
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Incomplete" message:@"You have not selected anything to push." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[av show];
	} else {
			if (self.baseTradeBuilding.usesEssentia) {
			UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"This will cost 2 essentia. Do you wish to contine?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
			actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
			[actionSheet showFromTabBar:self.tabBarController.tabBar];
			[actionSheet release];
		} else {
			[self pushItems];
		}
	}
}


#pragma mark -
#pragma mark PickColonyDelegate Methods

- (void)colonySelected:(NSString *)colonyId {
	self.itemPush.targetId = colonyId;
	[self dismissModalViewControllerAnimated:YES];
	[self->pickColonyController release];
	self->pickColonyController = nil;
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark SelectGlyphDelegate Methods

- (void)glyphSelected:(Glyph *)glyph {
	[self.itemPush addGlyph:glyph.id];
	[self.navigationController popViewControllerAnimated:YES];
	[self->selectGlyphController release];
	self->selectGlyphController = nil;
	[self.baseTradeBuilding.glyphs removeObject:glyph];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark SelectPlanDelegate Methods

- (void)planSelected:(Plan *)plan {
	[self.itemPush addPlan:plan.id];
	[self.navigationController popViewControllerAnimated:YES];
	[self->selectPlanController release];
	self->selectPlanController = nil;
	[self.baseTradeBuilding.plans removeObject:plan];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark SelectTradeablePrisonerController Methods

- (void)prisonerSelected:(Prisoner *)prisoner {
	[self.itemPush addPrisoner:prisoner.id];
	[self.navigationController popViewControllerAnimated:YES];
	[self->selectTradeablePrisonerController release];
	self->selectTradeablePrisonerController = nil;
	[self.baseTradeBuilding.prisoners removeObject:prisoner];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark SelectStoredResourcesDelegate Methods

- (void)storedResourceSelected:(NSDictionary *)storedResource {
	[self.itemPush addResourceType:[storedResource objectForKey:@"type"] withQuantity:[storedResource objectForKey:@"quantity"]];
	[self.navigationController popViewControllerAnimated:YES];
	[self->selectStoredResourceController release];
	self->selectStoredResourceController = nil;
	//[self.baseTradeBuilding.storedResources removeObject:storedResource];
	[self.baseTradeBuilding removeTradeableStoredResource:storedResource];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark SelectTradeableShipController Methods

- (void)shipSelected:(Ship *)ship {
	[self.itemPush addShip:ship.id];
	[self.navigationController popViewControllerAnimated:YES];
	[self->selectTradeableShipController release];
	self->selectTradeableShipController = nil;
	[self.baseTradeBuilding.ships removeObject:ship];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark PrivateMethods

- (void)showColonyPicker {
	Session *session = [Session	 sharedInstance];
	self->pickColonyController = [[PickColonyController create] retain];
	self->pickColonyController.delegate = self;
	self->pickColonyController.colonies = session.empire.planets;
	[self presentModalViewController:self->pickColonyController animated:YES];
}


- (void)pushItems {
	[self.baseTradeBuilding pushItems:self.itemPush target:self callback:@selector(pushedItems:)];
}



#pragma mark -
#pragma mark Callbacks

- (id)pushedItems:(LEBuildingPushItems *)request {
	if ([request wasError]) {
		NSString *errorText = [request errorMessage];
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Could not push items." message:errorText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
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
		[self pushItems];
	}
}


#pragma mark -
#pragma mark Class Methods

+ (NewItemPushController *)create {
	return [[[NewItemPushController alloc] init] autorelease];
}


@end

