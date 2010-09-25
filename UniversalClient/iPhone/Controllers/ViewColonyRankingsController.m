//
//  ViewColonyRankingsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewColonyRankingsController.h"
#import "LEMacros.h"
#import "Util.h"
#import "LEStatsColonyRank.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellLongLabeledText.h"


typedef enum {
	ROW_EMPIRE,
	ROW_PLANET,
	ROW_POPULATION,
	ROW_BUILDING_COUNT,
	ROW_AVERAGE_BUILDING_LEVEL,
	ROW_HIGHEST_BUILDING_LEVEL,
} ROW;

@implementation ViewColonyRankingsController


@synthesize sortBy;
@synthesize colonies;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if ([self.sortBy isEqualToString:@"population_rank"]) {
		self.navigationItem.title = @"Largest Colonies";
	} else {
		self.navigationItem.title = @"Colonies";
	}
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[[[LEStatsColonyRank alloc] initWithCallback:@selector(coloniesLoaded:) target:self sortBy:self.sortBy] autorelease];
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
	if (self.colonies) {
		if ([self.colonies count] > 0) {
			return [self.colonies count];
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.colonies) {
		if ([self.colonies count] > 0) {
			return 6;
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.colonies) {
		if ([self.colonies count] > 0) {
			switch (indexPath.row) {
				case ROW_EMPIRE:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_PLANET:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_POPULATION:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_BUILDING_COUNT:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_AVERAGE_BUILDING_LEVEL:
					return [LETableViewCellLongLabeledText getHeightForTableView:tableView];
					break;
				case ROW_HIGHEST_BUILDING_LEVEL:
					return [LETableViewCellLongLabeledText getHeightForTableView:tableView];
					break;
				default:
					return 0.0;
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
    
    UITableViewCell *cell;
	
	if (self.colonies) {
		if ([self.colonies count] > 0) {
			NSMutableDictionary *colony = [self.colonies objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_EMPIRE:
					; // DO NOT REMVOE
					LETableViewCellLabeledText *empireCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					empireCell.label.text = @"Empire";
					empireCell.content.text = [colony objectForKey:@"empire_name"];
					cell = empireCell;
					break;
				case ROW_PLANET:
					; // DO NOT REMVOE
					LETableViewCellLabeledText *planetCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					planetCell.label.text = @"Planet";
					planetCell.content.text = [colony objectForKey:@"planet_name"];
					cell = planetCell;
					break;
				case ROW_POPULATION:
					; // DO NOT REMVOE
					LETableViewCellLabeledText *populationCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					populationCell.label.text = @"Population";
					populationCell.content.text = [colony objectForKey:@"population"];
					cell = populationCell;
					break;
				case ROW_BUILDING_COUNT:
					; // DO NOT REMVOE
					LETableViewCellLabeledText *buildingCountCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					buildingCountCell.label.text = @"# Buildings";
					buildingCountCell.content.text = [colony objectForKey:@"building_count"];
					cell = buildingCountCell;
					break;
				case ROW_AVERAGE_BUILDING_LEVEL:
					; // DO NOT REMVOE
					LETableViewCellLongLabeledText *averageBuildingLevelCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
					averageBuildingLevelCell.label.text = @"Average Building Level";
					averageBuildingLevelCell.content.text = [colony objectForKey:@"average_building_level"];
					cell = averageBuildingLevelCell;
					break;
				case ROW_HIGHEST_BUILDING_LEVEL:
					; // DO NOT REMVOE
					LETableViewCellLongLabeledText *highestBuildingLevelCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
					highestBuildingLevelCell.label.text = @"Highest Building Level";
					highestBuildingLevelCell.content.text = [colony objectForKey:@"highest_building_level"];
					cell = highestBuildingLevelCell;
					break;
				default:
					cell = nil;
					break;
			}
		} else {
			LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			emptyCell.label.text = @"Colonies";
			emptyCell.content.text = @"None";
			cell = emptyCell;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Colonies";
		loadingCell.content.text = @"Loading";
		cell = loadingCell;
	}
    
    return cell;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.colonies = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	self.sortBy = nil;
	self.colonies = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callback Methods

- (id)coloniesLoaded:(LEStatsColonyRank *)request {
	self.colonies = request.colonies;
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[self.colonies count]];
	for (int i=0; i < [self.colonies count]; i++) {
		[tmp addObject:[LEViewSectionTab tableView:self.tableView withText:[NSString stringWithFormat:@"Colony %i", (i+1)]]];
	}
	self.sectionHeaders = tmp;
	[self.tableView reloadData];
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (ViewColonyRankingsController *)create {
	return [[[ViewColonyRankingsController alloc] init] autorelease];
}


@end

