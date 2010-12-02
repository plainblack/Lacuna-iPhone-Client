//
//  ViewUpgradableBuildingsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 11/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewUpgradableBuildingsController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "Building.h"
#import "HallsOfVrbansk.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellBuildingStats.h"
#import "LETableViewCellLabeledText.h"
#import "LEBuildingGetUpgradableBuildings.h"
#import "LEBuildingSacrificeToUpgrade.h"


typedef enum {
	ROW_BUILDING_INFO,
	ROW_SACRIFICE_BUTTON,
} ROW;


@implementation ViewUpgradableBuildingsController


@synthesize hallsOfVrbansk;
@synthesize upgradableBuildings;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Upgradable";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = nil;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.tableView reloadData];
	[self.hallsOfVrbansk getUpgradableBuildingsTarget:self callback:@selector(loadedUpgradableBuildings:)];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return MIN([self.upgradableBuildings count], 1);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.upgradableBuildings) {
		if ([self.upgradableBuildings count] > 0) {
			return 2;
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.upgradableBuildings) {
		if ([self.upgradableBuildings count] > 0) {
			switch (indexPath.row) {
				case ROW_BUILDING_INFO:
					return [LETableViewCellBuildingStats getHeightForTableView:tableView];
					break;
				case ROW_SACRIFICE_BUTTON:
					return [LETableViewCellButton getHeightForTableView:tableView];
					break;
				default:
					return 0;
					break;
			}
		} else {
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
		}
	} else {
		return [LETableViewCellLabeledText getHeightForTableView:tableView];
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
	if (self.upgradableBuildings) {
		if ([self.upgradableBuildings count] > 0) {
			Building *upgradableBuilding = [self.upgradableBuildings objectAtIndex:indexPath.section];
			
			switch (indexPath.row) {
				case ROW_BUILDING_INFO:
					; //DO NOT REMOVE
					Session *session = [Session sharedInstance];
					LETableViewCellBuildingStats *buildingStatsCell = [LETableViewCellBuildingStats getCellForTableView:tableView];
					[buildingStatsCell setBuildingImage:[UIImage imageNamed:[NSString stringWithFormat:@"/assets/planet_side/100/%@.png", upgradableBuilding.imageName]]];
					[buildingStatsCell setBuildingBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"assets/planet_side/%@.jpg", session.body.surfaceImageName]]];
					[buildingStatsCell setBuildingLevel:upgradableBuilding.level];
					[buildingStatsCell setResourceGeneration:upgradableBuilding.resourcesPerHour];
					cell = buildingStatsCell;
					break;
				case ROW_SACRIFICE_BUTTON:
					; //DO NOT REMOVE
					LETableViewCellButton *sacrificeButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					sacrificeButtonCell.textLabel.text = @"Upgrade";
					cell = sacrificeButtonCell;
					break;
				default:
					return 0;
					break;
			}
		} else {
			; //DO NOT REMOVE
			LETableViewCellLabeledText *noneCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			noneCell.label.text = @"Buildings";
			noneCell.content.text = @"None";
			cell = noneCell;
		}
	} else {
		; //DO NOT REMOVE
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Buildings";
		loadingCell.content.text = @"Loading";
		cell = loadingCell;
	}
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case ROW_SACRIFICE_BUTTON:
			; //DO NOT REMOVE
//			SelectEmpireController *selectEmpireController = [SelectEmpireController create];
//			selectEmpireController.delegate = self;
//			[self.navigationController pushViewController:selectEmpireController animated:YES];
//			break;
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
	self.hallsOfVrbansk = nil;
	self.upgradableBuildings = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callback Methods

- (void)loadedUpgradableBuildings:(LEBuildingGetUpgradableBuildings *)request {
	self.upgradableBuildings = request.buildings;
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewUpgradableBuildingsController *)create {
	return [[[ViewUpgradableBuildingsController alloc] init] autorelease];
}


@end

