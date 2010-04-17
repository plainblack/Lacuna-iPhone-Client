//
//  ViewBuildingController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewBuildingController.h"
#import "LEMacros.h"
#import "Util.h"
#import "LEViewSectionTab.h"
#import "LEGetBuilding.h"
#import "LEUpgradeBuilding.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellBuildingStats.h"
#import "LETableViewCellCost.h"
#import "LETableViewCellUnbuildable.h"


typedef enum {
	SECTION_BUILDING,
	SECTION_UPGRADE
} SECTION;

typedef enum {
	UPGRADE_BUILDING_STATS,
	UPGRADE_BUILDING_PROGRESS
} UPGRADE_BUILDING;

typedef enum {
	UPGRADE_NOT_BUILDING_STATS,
	UPGRADE_NOT_BUILDING_COST,
	UPGRADE_NOT_BUILDING_UPGRADE
} UPGRADE_NOT_BUILDING;


@implementation ViewBuildingController


@synthesize buildingId;
@synthesize buildingData;
@synthesize urlPart;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = array_([LEViewSectionTab tableView:self.tableView createWithText:@"Building"],
								 [LEViewSectionTab tableView:self.tableView createWithText:@"Upgrade"]);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	if (self.buildingData) {
		self.buildingId = [self.buildingData objectForKey:@"id"];
		self.navigationItem.title = [self.buildingData objectForKey:@"name"];
	} else {
		[[LEGetBuilding alloc] initWithCallback:@selector(bodyDataLoaded:) target:self buildingId:self.buildingId url:self.urlPart];
		
		self.navigationItem.title = @"Loading";
	}
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.buildingData) {
		return 2;
	} else {
		return 0;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	switch (section) {
		case SECTION_BUILDING:
			return 1;
			break;
		case SECTION_UPGRADE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			NSDictionary *pendingBuild = [self.buildingData objectForKey:@"pending_build"];
			
			if (pendingBuild) {
				return 2;
			} else {
				return 3;
			}
			break;
		default:
			return 0;
			break;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *pendingBuild = [self.buildingData objectForKey:@"pending_build"];
	
	switch (indexPath.section) {
		case SECTION_BUILDING:
			return 100.0;
			break;
		case SECTION_UPGRADE:
			if (pendingBuild) {
				switch (indexPath.row) {
					case UPGRADE_BUILDING_STATS:
						return 100.0;
						break;
					case UPGRADE_BUILDING_PROGRESS:
						return 50.0;
						break;
					default:
						return 5;
						break;
				}
			} else {
				switch (indexPath.row) {
					case UPGRADE_NOT_BUILDING_STATS:
						return 100.0;
						break;
					case UPGRADE_NOT_BUILDING_COST:
						return 65.0;
						break;
					case UPGRADE_NOT_BUILDING_UPGRADE:
						; //DO NOT REMOVE
						NSDictionary *upgrade = [self.buildingData objectForKey:@"upgrade"];
						BOOL canUpgrade = [[upgrade objectForKey:@"can"] boolValue];
						
						if (canUpgrade) {
							return [tableView rowHeight];
						} else {
							return 88.0;
						}
						break;
					default:
						return 5;
						break;
				}
			}
			break;
		default:
			return 5;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
	
	switch (indexPath.section) {
		case SECTION_BUILDING:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellBuildingStats *statsCell = [LETableViewCellBuildingStats getCellForTableView:tableView];
			[statsCell setBuildingImage:[UIImage imageNamed:[NSString stringWithFormat:@"/assets/planet_side/%@.png", [self.buildingData objectForKey:@"image"]]]];
			[statsCell setBuildingName:[self.buildingData objectForKey:@"name"] buildingLevel:[self.buildingData objectForKey:@"level"]];
			[statsCell setEnergyPerHour:[self.buildingData objectForKey:@"energy_hour"]];
			[statsCell setFoodPerHour:[self.buildingData objectForKey:@"food_hour"]];
			[statsCell setHappinessPerHour: [self.buildingData objectForKey:@"happiness_hour"]];
			[statsCell setOrePerHour: [self.buildingData objectForKey:@"ore_hour"]];
			[statsCell setWastePerHour:[self.buildingData objectForKey:@"waste_hour"]];
			[statsCell setWaterPerHour:[self.buildingData objectForKey:@"water_hour"]];
			cell = statsCell;
			break;
		case SECTION_UPGRADE:
			;
			NSDictionary *upgrade = [self.buildingData objectForKey:@"upgrade"];
			NSDictionary *pendingBuild = [self.buildingData objectForKey:@"pending_build"];
			BOOL canUpgrade = [[upgrade objectForKey:@"can"] boolValue];
			
			if (pendingBuild) {
				switch (indexPath.row) {
					case UPGRADE_BUILDING_STATS:
						; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
						NSDictionary *stats = [upgrade objectForKey:@"production"];
						LETableViewCellBuildingStats *statsCell = [LETableViewCellBuildingStats getCellForTableView:tableView];
						[statsCell setBuildingImage:[UIImage imageNamed:[NSString stringWithFormat:@"/assets/planet_side/%@.png", [upgrade objectForKey:@"image"]]]];
						[statsCell setBuildingName:[self.buildingData objectForKey:@"name"] buildingLevel:[NSNumber numberWithInt:intv_([self.buildingData objectForKey:@"level"])+1]];
						[statsCell setEnergyPerHour:[stats objectForKey:@"energy_hour"]];
						[statsCell setFoodPerHour:[stats objectForKey:@"food_hour"]];
						[statsCell setHappinessPerHour: [stats objectForKey:@"happiness_hour"]];
						[statsCell setOrePerHour: [stats objectForKey:@"ore_hour"]];
						[statsCell setWastePerHour:[stats objectForKey:@"waste_hour"]];
						[statsCell setWaterPerHour:[stats objectForKey:@"water_hour"]];
						cell = statsCell;
						break;
					case UPGRADE_BUILDING_PROGRESS:
						; //DO NOT REMOVE
						LETableViewCellProgress *pendingCell = [LETableViewCellProgress getCellForTableView:tableView];
						[pendingCell setTotalTime:totalBuildTime remainingTime:remainingBuildTime];
						pendingCell.delegate = self;
						cell = pendingCell;
						break;
					default:
						cell = nil;
						break;
				}
			} else {
				switch (indexPath.row) {
					case UPGRADE_NOT_BUILDING_STATS:
						; //DO NOT REMOVE
						NSDictionary *stats = [upgrade objectForKey:@"production"];
						LETableViewCellBuildingStats *statsCell = [LETableViewCellBuildingStats getCellForTableView:tableView];
						[statsCell setBuildingImage:[UIImage imageNamed:[NSString stringWithFormat:@"/assets/planet_side/%@.png", [upgrade objectForKey:@"image"]]]];
						[statsCell setBuildingName:[self.buildingData objectForKey:@"name"] buildingLevel:[NSNumber numberWithInt:intv_([self.buildingData objectForKey:@"level"])+1]];
						[statsCell setEnergyPerHour:[stats objectForKey:@"energy_hour"]];
						[statsCell setFoodPerHour:[stats objectForKey:@"food_hour"]];
						[statsCell setHappinessPerHour: [stats objectForKey:@"happiness_hour"]];
						[statsCell setOrePerHour: [stats objectForKey:@"ore_hour"]];
						[statsCell setWastePerHour:[stats objectForKey:@"waste_hour"]];
						[statsCell setWaterPerHour:[stats objectForKey:@"water_hour"]];
						cell = statsCell;
						break;
					case UPGRADE_NOT_BUILDING_COST:
						; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
						NSDictionary *cost = [upgrade objectForKey:@"cost"];
						LETableViewCellCost *costCell = [LETableViewCellCost getCellForTableView:tableView];
						[costCell setEnergyCost:[cost objectForKey:@"energy"]];
						[costCell setFoodCost:[cost objectForKey:@"food"]];
						[costCell setOreCost:[cost objectForKey:@"ore"]];
						[costCell setTimeCost:[cost objectForKey:@"time"]];
						[costCell setWasteCost:[cost objectForKey:@"waste"]];
						[costCell setWaterCost:[cost objectForKey:@"water"]];
						cell = costCell;
						break;
					case UPGRADE_NOT_BUILDING_UPGRADE:
						if (canUpgrade) {
							LETableViewCellButton *buttonCell = [LETableViewCellButton getCellForTableView:tableView];
							buttonCell.textLabel.text = @"Upgrade";
							cell = buttonCell;
						} else {
							LETableViewCellUnbuildable *unbuildableCell = [LETableViewCellUnbuildable getCellForTableView:tableView];
							NSArray *reason = [upgrade objectForKey:@"reason"];
							if ([reason count] > 2) {
								[unbuildableCell setReason:[NSString stringWithFormat:@"%@ (%@)", [reason objectAtIndex:1], [reason objectAtIndex:2]]];
							} else {
								[unbuildableCell setReason:[NSString stringWithFormat:@"%@", [reason objectAtIndex:1]]];
							}
							cell = unbuildableCell;
						}
						break;
					default:
						cell = nil;
						break;
				}
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
	if (indexPath.section == SECTION_UPGRADE && indexPath.row == UPGRADE_NOT_BUILDING_UPGRADE) {
		NSDictionary *upgrade = [self.buildingData objectForKey:@"upgrade"];
		BOOL canUpgrade = [[upgrade objectForKey:@"can"] boolValue];
		if (canUpgrade) {
			[[[LEUpgradeBuilding alloc] initWithCallback:@selector(upgradedBuilding:) target:self buildingId:self.buildingId buildingUrl:self.urlPart] autorelease];
		}
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
	self.buildingId = nil;
	self.buildingData = nil;
	self.urlPart = nil;
	[super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark -
#pragma mark LETableViewBuildProgressCellDelegate Methods

- (void)progressComplete {
	[[LEGetBuilding alloc] initWithCallback:@selector(bodyDataLoaded:) target:self buildingId:self.buildingId url:self.urlPart];
}


#pragma mark -
#pragma mark Callbacks

- (id)bodyDataLoaded:(LEGetBuilding *)request {
	self.buildingData = request.building;
	
	self.navigationItem.title = [self.buildingData objectForKey:@"name"];
	
	NSDictionary *pendingBuild = [self.buildingData objectForKey:@"pending_build"];
	if (pendingBuild) {
		NSDate *buildEndDate = [Util date:[pendingBuild objectForKey:@"end"]];
		NSDate *buildStartDate = [Util date:[pendingBuild objectForKey:@"start"]];
		totalBuildTime = (NSInteger)[buildEndDate timeIntervalSinceDate:buildStartDate];
		remainingBuildTime = intv_([pendingBuild objectForKey:@"seconds_remaining"]);
	} else {
		totalBuildTime = 0;
		remainingBuildTime = 0;
	}
	
	[self.tableView reloadData];
	
	return nil;
}


- (id)upgradedBuilding:(LEUpgradeBuilding *)request {
	[[LEGetBuilding alloc] initWithCallback:@selector(bodyDataLoaded:) target:self buildingId:self.buildingId url:self.urlPart];
	
	self.navigationItem.title = @"Refreshing";
	
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (ViewBuildingController *)create {
	return [[[ViewBuildingController alloc] init] autorelease];
}


@end

