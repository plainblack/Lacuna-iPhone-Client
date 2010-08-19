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
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellButton.h"
#import "PickColonyController.h"
#import "SelectGlyphController.h"
#import "SelectPlanController.h"
#import "SelectStoredResourceController.h"

typedef enum {
	SECTION_PUSH_TO,
	SECTION_ITEMS,
	SECTION_ADD
} SECTIONS;

typedef enum {
	ADD_ROW_GLYPH,
	ADD_ROW_PLAN,
	ADD_ROW_RESOURCE
} ADD_ROWS;


@interface NewItemPushController (PrivateMethods)

- (void)showColonyPicker;

@end


@implementation NewItemPushController


@synthesize baseTradeBuilding;
@synthesize itemPush;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView createWithText:@"Push To"], [LEViewSectionTab tableView:self.tableView createWithText:@"Items To Push"], [LEViewSectionTab tableView:self.tableView createWithText:@"Add"]);
	
	if (!self.itemPush) {
		self.itemPush = [[[ItemPush alloc] init] autorelease];
	}
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	if (!self.itemPush.targetId) {
		Session *session = [Session sharedInstance];
		if	([session.empire.planets count] == 2) {
			[session.empire.planets enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
				if (![key isEqualToString:session.body.id]) {
					self.itemPush.targetId = session.body.id;
					*stop = YES;
				}
			}];
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
			return 3;
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
				return [LETableViewCellLabeledText getHeightForTableView:tableView];
			} else {
				return [LETableViewCellLabeledText getHeightForTableView:tableView];
			}
			break;
		case SECTION_ADD:
			return [LETableViewCellButton getHeightForTableView:tableView];
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
				selectColonyButton.textLabel.text = [session.empire.planets objectForKey:self.itemPush.targetId];
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
				LETableViewCellLabeledText *itemCell = [LETableViewCellLabeledText getCellForTableView:tableView];
				NSString *type = [item objectForKey:@"type"];
				if ([type isEqualToString:@"glyph"]) {
					itemCell.label.text = @"Glyph";
					itemCell.content.text = [item objectForKey:@"glpyh_id"];
					//KEVIN how to get real glyph and display glyph?
				} else if ([type isEqualToString:@"plan"]) {
					itemCell.label.text = @"Plan";
					itemCell.content.text = [item objectForKey:@"plan_id"];
					//Kevin how to get real plan and display plan?
				} else {
					itemCell.label.text = [type capitalizedString];
					itemCell.content.text = [Util prettyNSDecimalNumber:[item objectForKey:@"quantity"]];
				}
			} else {
				LETableViewCellLabeledText *noItemsCell = [LETableViewCellLabeledText getCellForTableView:tableView];
				noItemsCell.label.text = @"None yet";
				noItemsCell.content.text = @"Go add some!";
				cell = noItemsCell;
			}
			break;
		case SECTION_ADD:
			switch (indexPath.row) {
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
				case ADD_ROW_RESOURCE:
					; //DO NOT REMOVE
					LETableViewCellButton *addResourceButton = [LETableViewCellButton getCellForTableView:tableView];
					addResourceButton.textLabel.text = @"Add Resource";
					cell = addResourceButton;
					break;
			}
			break;
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_PUSH_TO:
			[self showColonyPicker];
			break;
		case SECTION_ADD:
			switch (indexPath.row) {
				case ADD_ROW_GLYPH:
					; //DO NOT REMOVE
					SelectGlyphController *selectGlyphController = [SelectGlyphController create];
					selectGlyphController.baseTradeBuilding = self.baseTradeBuilding;
					[self.navigationController pushViewController:selectGlyphController animated:YES];
					break;
				case ADD_ROW_PLAN:
					; //DO NOT REMOVE
					SelectPlanController *selectPlanController = [SelectPlanController create];
					selectPlanController.baseTradeBuilding = self.baseTradeBuilding;
					[self.navigationController pushViewController:selectPlanController animated:YES];
					break;
				case ADD_ROW_RESOURCE:
					; //DO NOT REMOVE
					SelectStoredResourceController *selectStoredResourceController = [SelectStoredResourceController create];
					selectStoredResourceController.baseTradeBuilding = self.baseTradeBuilding;
					[self.navigationController pushViewController:selectStoredResourceController animated:YES];
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
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	self.baseTradeBuilding = nil;
	self.itemPush = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callback Methods

- (IBAction)save {
	NSLog(@"Action called");
}


#pragma mark -
#pragma mark PickColonyDelegate Methods

- (void)colonySelected:(NSString *)colonyId {
	self.itemPush.targetId = colonyId;
	[self dismissModalViewControllerAnimated:YES];
	[self->pickColonyController release];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark PrivateMethods

- (void)showColonyPicker {
	Session *session = [Session	 sharedInstance];
	self->pickColonyController = [[PickColonyController create] retain];
	self->pickColonyController.delegate = self;
	NSMutableArray *colonies = [NSMutableArray arrayWithCapacity:[session.empire.planets count]];
	[session.empire.planets enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
		if (![session.body.id isEqualToString:key]) {
			[colonies addObject:_dict(key, @"id", obj, @"name")];
		}
	}];
	self->pickColonyController.colonies = colonies;
	[self presentModalViewController:self->pickColonyController animated:YES];
}


#pragma mark -
#pragma mark Class Methods

+ (NewItemPushController *)create {
	return [[[NewItemPushController alloc] init] autorelease];
}


@end

