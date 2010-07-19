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
	SECTION_INFRASTRUCTURE,
	SECTION_RESOURCES,
	SECTION_ALL
} SECTION;

typedef enum {
	INFRASTRCUTURE_ROW_INTELLIGENCE,
	INFRASTRCUTURE_ROW_HAPPINESS,
	INFRASTRCUTURE_ROW_SHIPS,
	INFRASTRCUTURE_ROW_COLONIZATION
} INFRASTRCUTURE_ROW;

typedef enum {
	RESOURCE_ROW_ENERGY,
	RESOURCE_ROW_FOOD,
	RESOURCE_ROW_ORE,
	RESOURCE_ROW_WASTE,
	RESOURCE_ROW_WATER
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
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView createWithText:@"Infrastructure"], [LEViewSectionTab tableView:self.tableView createWithText:@"Resources"], [LEViewSectionTab tableView:self.tableView createWithText:@"All"]);
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
		case SECTION_INFRASTRUCTURE:
			return 4;
			break;
		case SECTION_RESOURCES:
			return 5;
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
	UITableViewCell *cell;
	
	NSLog(@"Getting Cell [%i,%i]", indexPath.section, indexPath.row);
	
	switch (indexPath.section) {
		case SECTION_INFRASTRUCTURE:
			switch (indexPath.row) {
				case INFRASTRCUTURE_ROW_INTELLIGENCE:
					; //DO NOT REMOVE
					LETableViewCellButton *intelligenceButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					intelligenceButtonCell.textLabel.text = @"Intelligence";
					cell = intelligenceButtonCell;
					break;
				case INFRASTRCUTURE_ROW_HAPPINESS:
					; //DO NOT REMOVE
					LETableViewCellButton *happinessButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					happinessButtonCell.textLabel.text = @"Happiness";
					cell = happinessButtonCell;
					break;
				case INFRASTRCUTURE_ROW_SHIPS:
					; //DO NOT REMOVE
					LETableViewCellButton *shipsButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					shipsButtonCell.textLabel.text = @"Ships";
					cell = shipsButtonCell;
					break;
				case INFRASTRCUTURE_ROW_COLONIZATION:
					; //DO NOT REMOVE
					LETableViewCellButton *colonizationButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					colonizationButtonCell.textLabel.text = @"Colonization";
					cell = colonizationButtonCell;
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
				default:
					cell = nil;
					break;
			}
			break;
		case SECTION_ALL:
			NSLog(@"Section All");
			switch (indexPath.row) {
				case ALL_ROW_FREE_PLANS:
					NSLog(@"Row Free Plans");
					; //DO NOT REMOVE
					LETableViewCellButton *freePlansButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					freePlansButtonCell.textLabel.text = @"Free Plans";
					cell = freePlansButtonCell;
					break;
				case ALL_ROW_ALL:
					NSLog(@"Row All");
					; //DO NOT REMOVE
					LETableViewCellButton *allButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					allButtonCell.textLabel.text = @"ALL";
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
	NSString *tag;
	
	switch (indexPath.section) {
		case SECTION_INFRASTRUCTURE:
			switch (indexPath.row) {
				case INFRASTRCUTURE_ROW_INTELLIGENCE:
					tag = @"Intelligence";
					break;
				case INFRASTRCUTURE_ROW_HAPPINESS:
					tag = @"Happiness";
					break;
				case INFRASTRCUTURE_ROW_SHIPS:
					tag = @"Ships";
					break;
				case INFRASTRCUTURE_ROW_COLONIZATION:
					tag = @"Colonization";
					break;
				default:
					tag = @"Infrastructure";
					break;
			}
			break;
		case SECTION_RESOURCES:
			switch (indexPath.row) {
				case RESOURCE_ROW_ENERGY:
					tag = @"Energy";
					break;
				case RESOURCE_ROW_FOOD:
					tag = @"Food";
					break;
				case RESOURCE_ROW_ORE:
					tag = @"Ore";
					break;
				case RESOURCE_ROW_WASTE:
					tag = @"Waste";
					break;
				case RESOURCE_ROW_WATER:
					tag = @"Water";
					break;
				default:
					tag = @"Resources";
					break;
			}
			break;
		case SECTION_ALL:
			switch (indexPath.row) {
				case ALL_ROW_FREE_PLANS:
					tag = @"Plan";
					break;
				case ALL_ROW_ALL:
					tag = @"";
					break;
				default:
					break;
			}
			break;
		default:
			tag =nil;
			break;
	}
	
	Session *session = [Session sharedInstance];
	NewBuildingController *newBuildingController = [NewBuildingController create];
	newBuildingController.bodyId = session.body.id;
	newBuildingController.buildingsByLoc = session.body.buildingMap;
	newBuildingController.buttonsByLoc = buttonsByLoc;
	newBuildingController.x = x;
	newBuildingController.y	= y;
	newBuildingController.tag = tag;
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
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
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

