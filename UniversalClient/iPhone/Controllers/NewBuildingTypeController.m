//
//  NewBuildingTypeController.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "NewBuildingTypeController.h"
#import "LEMacros.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "Session.h"
#import "NewBuildingController.h"


typedef enum {
	SECTION_RESOURCES,
	SECTION_INFRASTRUCTURE,
	SECTION_ALL
} SECTION;

typedef enum {
	INFRASTRCUTURE_ROW_COLONIZATION,
	INFRASTRCUTURE_ROW_CONSTRUCTION,
	INFRASTRCUTURE_ROW_HAPPINESS,
	INFRASTRCUTURE_ROW_INTELLIGENCE,
	INFRASTRCUTURE_ROW_SHIPS,
	INFRASTRCUTURE_ROW_TRADE,
	INFRASTRCUTURE_ROW_ALL
} INFRASTRCUTURE_ROW;

typedef enum {
	RESOURCE_ROW_ENERGY,
	RESOURCE_ROW_FOOD,
	RESOURCE_ROW_ORE,
	RESOURCE_ROW_STORAGE,
	RESOURCE_ROW_WASTE,
	RESOURCE_ROW_WATER,
	RESOURCE_ROW_ALL
} RESOURCE_ROW;

typedef enum {
	ALL_ROW_FREE_PLANS,
	ALL_ROW_ALL
} ALL_ROW;



@implementation NewBuildingTypeController


@synthesize buttonsByLoc;
@synthesize x;
@synthesize y;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Resources"], [LEViewSectionTab tableView:self.tableView withText:@"Infrastructure"], [LEViewSectionTab tableView:self.tableView withText:@"All"]);
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
		case SECTION_INFRASTRUCTURE:
			return 7;
			break;
		case SECTION_RESOURCES:
			return 7;
			break;
		case SECTION_ALL:
			return 2;
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
		case SECTION_INFRASTRUCTURE:
			switch (indexPath.row) {
				case INFRASTRCUTURE_ROW_COLONIZATION:
					; //DO NOT REMOVE
					LETableViewCellButton *colonizationButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					colonizationButtonCell.textLabel.text = @"Colonization";
					cell = colonizationButtonCell;
					break;
				case INFRASTRCUTURE_ROW_CONSTRUCTION:
					; //DO NOT REMOVE
					LETableViewCellButton *constructionButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					constructionButtonCell.textLabel.text = @"Construction";
					cell = constructionButtonCell;
					break;
				case INFRASTRCUTURE_ROW_HAPPINESS:
					; //DO NOT REMOVE
					LETableViewCellButton *happinessButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					happinessButtonCell.textLabel.text = @"Happiness";
					cell = happinessButtonCell;
					break;
				case INFRASTRCUTURE_ROW_INTELLIGENCE:
					; //DO NOT REMOVE
					LETableViewCellButton *intelligenceButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					intelligenceButtonCell.textLabel.text = @"Intelligence";
					cell = intelligenceButtonCell;
					break;
				case INFRASTRCUTURE_ROW_SHIPS:
					; //DO NOT REMOVE
					LETableViewCellButton *shipsButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					shipsButtonCell.textLabel.text = @"Ships";
					cell = shipsButtonCell;
					break;
				case INFRASTRCUTURE_ROW_TRADE:
					; //DO NOT REMOVE
					LETableViewCellButton *tradeButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					tradeButtonCell.textLabel.text = @"Trade";
					cell = tradeButtonCell;
					break;
				case INFRASTRCUTURE_ROW_ALL:
					; //DO NOT REMOVE
					LETableViewCellButton *infrastructureAllButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					infrastructureAllButtonCell.textLabel.text = @"All Infrastructure";
					cell = infrastructureAllButtonCell;
					break;
				default:
					cell = nil;
					break;
			}
			break;
		case SECTION_RESOURCES:
			switch (indexPath.row) {
				case RESOURCE_ROW_ENERGY:
					; //DO NOT REMOVE
					LETableViewCellButton *energyButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					energyButtonCell.textLabel.text = @"Energy";
					cell = energyButtonCell;
					break;
				case RESOURCE_ROW_FOOD:
					; //DO NOT REMOVE
					LETableViewCellButton *foodButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					foodButtonCell.textLabel.text = @"Food";
					cell = foodButtonCell;
					break;
				case RESOURCE_ROW_ORE:
					; //DO NOT REMOVE
					LETableViewCellButton *oreButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					oreButtonCell.textLabel.text = @"Ore";
					cell = oreButtonCell;
					break;
				case RESOURCE_ROW_STORAGE:
					; //DO NOT REMOVE
					LETableViewCellButton *storageButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					storageButtonCell.textLabel.text = @"Storage";
					cell = storageButtonCell;
					break;
				case RESOURCE_ROW_WASTE:
					; //DO NOT REMOVE
					LETableViewCellButton *wasteButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					wasteButtonCell.textLabel.text = @"Waste";
					cell = wasteButtonCell;
					break;
				case RESOURCE_ROW_WATER:
					; //DO NOT REMOVE
					LETableViewCellButton *waterButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					waterButtonCell.textLabel.text = @"Water";
					cell = waterButtonCell;
					break;
				case RESOURCE_ROW_ALL:
					; //DO NOT REMOVE
					LETableViewCellButton *allResourcesButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					allResourcesButtonCell.textLabel.text = @"All Resources";
					cell = allResourcesButtonCell;
					break;
				default:
					cell = nil;
					break;
			}
			break;
		case SECTION_ALL:
			switch (indexPath.row) {
				case ALL_ROW_FREE_PLANS:
					; //DO NOT REMOVE
					LETableViewCellButton *freePlansButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					freePlansButtonCell.textLabel.text = @"Free Plans";
					cell = freePlansButtonCell;
					break;
				case ALL_ROW_ALL:
					; //DO NOT REMOVE
					LETableViewCellButton *allButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					allButtonCell.textLabel.text = @"All Buildings";
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
	
	Session *session = [Session sharedInstance];
	NewBuildingController *newBuildingController = [NewBuildingController create];
	newBuildingController.bodyId = session.body.id;
	newBuildingController.buttonsByLoc = buttonsByLoc;
	newBuildingController.x = x;
	newBuildingController.y	= y;
	switch (indexPath.section) {
		case SECTION_INFRASTRUCTURE:
			switch (indexPath.row) {
				case INFRASTRCUTURE_ROW_COLONIZATION:
					newBuildingController.tag = @"Colonization";
					break;
				case INFRASTRCUTURE_ROW_CONSTRUCTION:
					newBuildingController.tag = @"Construction";
					break;
				case INFRASTRCUTURE_ROW_HAPPINESS:
					newBuildingController.tag = @"Happiness";
					break;
				case INFRASTRCUTURE_ROW_INTELLIGENCE:
					newBuildingController.tag = @"Intelligence";
					break;
				case INFRASTRCUTURE_ROW_SHIPS:
					newBuildingController.tag = @"Ships";
					break;
				case INFRASTRCUTURE_ROW_TRADE:
					newBuildingController.tag = @"Trade";
					break;
				case INFRASTRCUTURE_ROW_ALL:
					newBuildingController.tag = @"Infrastructure";
					break;
				default:
					newBuildingController.tag = @"Infrastructure";
					break;
			}
			break;
		case SECTION_RESOURCES:
			switch (indexPath.row) {
				case RESOURCE_ROW_ENERGY:
					newBuildingController.tag = @"Energy";
					break;
				case RESOURCE_ROW_FOOD:
					newBuildingController.tag = @"Food";
					break;
				case RESOURCE_ROW_ORE:
					newBuildingController.tag = @"Ore";
					break;
				case RESOURCE_ROW_STORAGE:
					newBuildingController.tag = @"Storage";
					break;
				case RESOURCE_ROW_WASTE:
					newBuildingController.tag = @"Waste";
					break;
				case RESOURCE_ROW_WATER:
					newBuildingController.tag = @"Water";
					break;
				case RESOURCE_ROW_ALL:
					newBuildingController.tag = @"Resources";
					break;
				default:
					newBuildingController.tag = @"Resources";
					break;
			}
			break;
		case SECTION_ALL:
			switch (indexPath.row) {
				case ALL_ROW_FREE_PLANS:
					newBuildingController.tag = @"Plan";
					break;
				case ALL_ROW_ALL:
					newBuildingController.tag = @"";
					break;
				default:
					newBuildingController.tag = @"";
					break;
			}
			break;
		default:
			newBuildingController.tag = @"";
			break;
	}
	
	[[self navigationController] pushViewController:newBuildingController animated:YES];
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
	self.buttonsByLoc = nil;
	self.x = nil;
	self.y = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Class Methods

+ (NewBuildingTypeController *)create {
	return [[[NewBuildingTypeController alloc] init] autorelease];
}


@end

