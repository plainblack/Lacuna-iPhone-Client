//
//  ViewShipsByTypeController.m
//  UniversalClient
//
//  Created by Kevin Runde on 2/23/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "ViewShipsByTypeController.h"
#import "LEMacros.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "SpacePort.h"
#import "ViewShipsController.h"


typedef enum {
	SECTION_CATEGORY,
	SECTION_TASK,
	SECTION_ALL
} SECTION;

typedef enum {
	CATEGORY_ROW_COLONIZATION,
	CATEGORY_ROW_EXPLORATION,
	CATEGORY_ROW_INTELLIGENCE,
	CATEGORY_ROW_MINING,
	CATEGORY_ROW_TRADE,
	CATEGORY_ROW_WAR,
} CATEGORY_ROW;

typedef enum {
	TASK_ROW_BUILDING,
	TASK_ROW_DEFEND,
	TASK_ROW_DOCKED,
	TASK_ROW_MINING,
    TASK_ROW_ORBITING,
	TASK_ROW_TRAVELLING,
} TASK_ROW;

typedef enum {
	ALL_ROW_ALL
} ALL_ROW;



@implementation ViewShipsByTypeController


@synthesize spaceport;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.title = @"Ship Types";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];

	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Category"], [LEViewSectionTab tableView:self.tableView withText:@"Task"], [LEViewSectionTab tableView:self.tableView withText:@"All"]);
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
		case SECTION_CATEGORY:
			return 6;
			break;
		case SECTION_TASK:
			return 6;
			break;
		case SECTION_ALL:
			return 1;
			break;
		default:
			return 0;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
	switch (indexPath.section) {
		case SECTION_CATEGORY:
			switch (indexPath.row) {
				case CATEGORY_ROW_COLONIZATION:
					; //DO NOT REMOVE
					LETableViewCellButton *colonizationButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					colonizationButtonCell.textLabel.text = @"Colonization";
					cell = colonizationButtonCell;
					break;
				case CATEGORY_ROW_EXPLORATION:
					; //DO NOT REMOVE
					LETableViewCellButton *explorationButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					explorationButtonCell.textLabel.text = @"Exploration";
					cell = explorationButtonCell;
					break;
				case CATEGORY_ROW_INTELLIGENCE:
					; //DO NOT REMOVE
					LETableViewCellButton *intelligenceButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					intelligenceButtonCell.textLabel.text = @"Intelligence";
					cell = intelligenceButtonCell;
					break;
				case CATEGORY_ROW_MINING:
					; //DO NOT REMOVE
					LETableViewCellButton *miningButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					miningButtonCell.textLabel.text = @"Mining";
					cell = miningButtonCell;
					break;
				case CATEGORY_ROW_TRADE:
					; //DO NOT REMOVE
					LETableViewCellButton *tradeButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					tradeButtonCell.textLabel.text = @"Trade";
					cell = tradeButtonCell;
					break;
				case CATEGORY_ROW_WAR:
					; //DO NOT REMOVE
					LETableViewCellButton *warButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					warButtonCell.textLabel.text = @"War";
					cell = warButtonCell;
					break;
				default:
					cell = nil;
					break;
			}
			break;
		case SECTION_TASK:
			switch (indexPath.row) {
				case TASK_ROW_BUILDING:
					; //DO NOT REMOVE
					LETableViewCellButton *buildingButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					buildingButtonCell.textLabel.text = @"Building";
					cell = buildingButtonCell;
					break;
				case TASK_ROW_DEFEND:
					; //DO NOT REMOVE
					LETableViewCellButton *defendButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					defendButtonCell.textLabel.text = @"Defend";
					cell = defendButtonCell;
					break;
				case TASK_ROW_DOCKED:
					; //DO NOT REMOVE
					LETableViewCellButton *dockedButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					dockedButtonCell.textLabel.text = @"Docked";
					cell = dockedButtonCell;
					break;
				case TASK_ROW_MINING:
					; //DO NOT REMOVE
					LETableViewCellButton *miningButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					miningButtonCell.textLabel.text = @"Mining";
					cell = miningButtonCell;
					break;
				case TASK_ROW_ORBITING:
					; //DO NOT REMOVE
					LETableViewCellButton *orbitingButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					orbitingButtonCell.textLabel.text = @"Orbiting";
					cell = orbitingButtonCell;
					break;
				case TASK_ROW_TRAVELLING:
					; //DO NOT REMOVE
					LETableViewCellButton *travellingButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					travellingButtonCell.textLabel.text = @"Travelling";
					cell = travellingButtonCell;
					break;
				default:
					cell = nil;
					break;
			}
			break;
		case SECTION_ALL:
			switch (indexPath.row) {
				case ALL_ROW_ALL:
					; //DO NOT REMOVE
					LETableViewCellButton *allButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					allButtonCell.textLabel.text = @"All Ships";
					cell = allButtonCell;
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
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.spaceport.ships = nil;
	ViewShipsController *viewShipsController = [ViewShipsController create];
	viewShipsController.spacePort = self.spaceport;
	viewShipsController.task = nil;
	viewShipsController.tag = nil;
	switch (indexPath.section) {
		case SECTION_CATEGORY:
			switch (indexPath.row) {
				case CATEGORY_ROW_COLONIZATION:
					viewShipsController.tag = @"Colonization";
					break;
				case CATEGORY_ROW_EXPLORATION:
					viewShipsController.tag = @"Exploration";
					break;
				case CATEGORY_ROW_INTELLIGENCE:
					viewShipsController.tag = @"Intelligence";
					break;
				case CATEGORY_ROW_MINING:
					viewShipsController.tag = @"Mining";
					break;
				case CATEGORY_ROW_TRADE:
					viewShipsController.tag = @"Trade";
					break;
				case CATEGORY_ROW_WAR:
					viewShipsController.tag = @"War";
					break;
				default:
					viewShipsController.tag = @"";
					break;
			}
			break;
		case SECTION_TASK:
			switch (indexPath.row) {
				case TASK_ROW_BUILDING:
					viewShipsController.task = @"Building";
					break;
				case TASK_ROW_DEFEND:
					viewShipsController.task = @"Defend";
					break;
				case TASK_ROW_DOCKED:
					viewShipsController.task = @"Docked";
					break;
				case TASK_ROW_MINING:
					viewShipsController.task = @"Mining";
					break;
				case TASK_ROW_ORBITING:
					viewShipsController.task = @"Orbiting";
					break;
				case TASK_ROW_TRAVELLING:
					viewShipsController.task = @"Travelling";
					break;
			}
			break;
	}
	
	[[self navigationController] pushViewController:viewShipsController animated:YES];
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
	self.spaceport = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewShipsByTypeController *)create {
	return [[[ViewShipsByTypeController alloc] init] autorelease];
}


@end

