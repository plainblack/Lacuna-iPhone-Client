//
//  ViewRacialStatsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewSpeciesStatsController.h"
#import "LEMacros.h"
#import "Util.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellLongLabeledText.h"
#import "LETableViewCellLabeledParagraph.h"
#import "LEEmpireViewSpeciesStats.h"


typedef enum {
	SECTION_INFO,
	SECTION_HABITABLE_ORBITS,
	SECTION_AFFINITY
} SECTION;


typedef enum {
	INFO_ROW_NAME,
	INFO_ROW_DESCRIPTION
} INFO_ROW;


typedef enum {
	HABITIABLE_ORBIT_ROW_MIN,
	HABITIABLE_ORBIT_ROW_MAX,
} HABITABLE_ORBIT_ROW;


typedef enum {
	AFFINITY_ROW_DECEPTION,
	AFFINITY_ROW_ENVIRONMENTAL,
	AFFINITY_ROW_FARMING,
	AFFINITY_ROW_GROWTH,
	AFFINITY_ROW_MANGEMENT,
	AFFINITY_ROW_MANUFACTURING,
	AFFINITY_ROW_MINING,
	AFFINITY_ROW_POLITICAL,
	AFFINITY_ROW_RESEARCH,
	AFFINITY_ROW_SCIENCE,
	AFFINITY_ROW_TRADE
} AFFINITY_ROW;


@implementation ViewSpeciesStatsController


@synthesize racialStats;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Racial Stats";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Info"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Habitable Orbits"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Affinities"]);
}



- (void)viewWillAppear:(BOOL)animated {
	[[[LEEmpireViewSpeciesStats alloc] initWithCallback:@selector(viewRacialStatsController:) target:self] autorelease];
    [super viewWillAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.racialStats) {
		return 3;
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.racialStats) {
		switch (section) {
			case SECTION_INFO:
				return 2;
				break;
			case SECTION_HABITABLE_ORBITS:
				return 2;
				break;
			case SECTION_AFFINITY:
				return 11;
				break;
			default:
				return 0;
				break;
		}
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.racialStats) {
		switch (indexPath.section) {
			case SECTION_INFO:
				switch (indexPath.row) {
					case INFO_ROW_NAME:
						return [LETableViewCellLongLabeledText getHeightForTableView:tableView];
						break;
					case INFO_ROW_DESCRIPTION:
						return [LETableViewCellLabeledParagraph getHeightForTableView:tableView text:[self.racialStats objectForKey:@"description"]];
						break;
					default:
						return 0.0;
				}
				break;
			case SECTION_HABITABLE_ORBITS:
				switch (indexPath.row) {
					case HABITIABLE_ORBIT_ROW_MIN:
					case HABITIABLE_ORBIT_ROW_MAX:
						return [LETableViewCellLongLabeledText getHeightForTableView:tableView];
						break;
					default:
						return 0.0;
				}
				break;
			case SECTION_AFFINITY:
				switch (indexPath.row) {
					case AFFINITY_ROW_DECEPTION:
					case AFFINITY_ROW_ENVIRONMENTAL:
					case AFFINITY_ROW_FARMING:
					case AFFINITY_ROW_GROWTH:
					case AFFINITY_ROW_MANGEMENT:
					case AFFINITY_ROW_MANUFACTURING:
					case AFFINITY_ROW_MINING:
					case AFFINITY_ROW_POLITICAL:
					case AFFINITY_ROW_RESEARCH:
					case AFFINITY_ROW_SCIENCE:
					case AFFINITY_ROW_TRADE:
						return [LETableViewCellLongLabeledText getHeightForTableView:tableView];
						break;
					default:
						return 0.0;
				}
				break;
			default:
				return 0;
				break;
		}
	} else {
		return [LETableViewCellLabeledText getHeightForTableView:tableView];
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	
	if (self.racialStats) {
		switch (indexPath.section) {
			case SECTION_INFO:
				switch (indexPath.row) {
					case INFO_ROW_NAME:
						; //DO NOT REMOVE
						LETableViewCellLabeledText *nameCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
						nameCell.label.text = @"Name";
						nameCell.content.text = [self.racialStats objectForKey:@"name"];
						cell = nameCell;
						break;
					case INFO_ROW_DESCRIPTION:
						; //DO NOT REMOVE
						LETableViewCellLabeledParagraph *descriptionCell = [LETableViewCellLabeledParagraph getCellForTableView:tableView];
						descriptionCell.label.text = @"Description";
						descriptionCell.content.text = [self.racialStats objectForKey:@"description"];
						cell = descriptionCell;
						break;
					default:
						cell = nil;
				}
				break;
			case SECTION_HABITABLE_ORBITS:
				switch (indexPath.row) {
					case HABITIABLE_ORBIT_ROW_MIN:
						; //DO NOT REMOVE
						LETableViewCellLongLabeledText *minOrbitCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
						minOrbitCell.label.text = @"Min Orbit";
						minOrbitCell.content.text = [self.racialStats objectForKey:@"min_orbit"];
						cell = minOrbitCell;
						break;
					case HABITIABLE_ORBIT_ROW_MAX:
						; //DO NOT REMOVE
						LETableViewCellLongLabeledText *maxOrbitCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
						maxOrbitCell.label.text = @"Max Orbit";
						maxOrbitCell.content.text = [self.racialStats objectForKey:@"max_orbit"];
						cell = maxOrbitCell;
						break;
					default:
						cell = nil;
				}
				break;
			case SECTION_AFFINITY:
				switch (indexPath.row) {
					case AFFINITY_ROW_DECEPTION:
						; //DO NOT REMOVE
						LETableViewCellLongLabeledText *deceptionCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
						deceptionCell.label.text = @"Deception Affinity";
						deceptionCell.content.text = [NSString stringWithFormat:@"%@", [self.racialStats objectForKey:@"deception_affinity"]];
						cell = deceptionCell;
						break;
					case AFFINITY_ROW_ENVIRONMENTAL:
						; //DO NOT REMOVE
						LETableViewCellLongLabeledText *environmentalCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
						environmentalCell.label.text = @"Environmental Affinity";
						environmentalCell.content.text = [NSString stringWithFormat:@"%@", [self.racialStats objectForKey:@"environmental_affinity"]];
						cell = environmentalCell;
						break;
					case AFFINITY_ROW_FARMING:
						; //DO NOT REMOVE
						LETableViewCellLongLabeledText *farmingCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
						farmingCell.label.text = @"Farming Affinity";
						farmingCell.content.text = [NSString stringWithFormat:@"%@", [self.racialStats objectForKey:@"farming_affinity"]];
						cell = farmingCell;
						break;
					case AFFINITY_ROW_GROWTH:
						; //DO NOT REMOVE
						LETableViewCellLongLabeledText *growthCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
						growthCell.label.text = @"Growth Affinity";
						growthCell.content.text = [NSString stringWithFormat:@"%@", [self.racialStats objectForKey:@"growth_affinity"]];
						cell = growthCell;
						break;
					case AFFINITY_ROW_MANGEMENT:
						; //DO NOT REMOVE
						LETableViewCellLongLabeledText *loadingCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
						loadingCell.label.text = @"Management Affinity";
						loadingCell.content.text = [NSString stringWithFormat:@"%@", [self.racialStats objectForKey:@"management_affinity"]];
						cell = loadingCell;
						break;
					case AFFINITY_ROW_MANUFACTURING:
						; //DO NOT REMOVE
						LETableViewCellLongLabeledText *manufacturingCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
						manufacturingCell.label.text = @"Manufacturing Affinity";
						manufacturingCell.content.text = [NSString stringWithFormat:@"%@", [self.racialStats objectForKey:@"manufacturing_affinity"]];
						cell = manufacturingCell;
						break;
					case AFFINITY_ROW_MINING:
						; //DO NOT REMOVE
						LETableViewCellLongLabeledText *miningCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
						miningCell.label.text = @"Mining Affinity";
						miningCell.content.text = [NSString stringWithFormat:@"%@", [self.racialStats objectForKey:@"mining_affinity"]];
						cell = miningCell;
						break;
					case AFFINITY_ROW_POLITICAL:
						; //DO NOT REMOVE
						LETableViewCellLongLabeledText *politicalCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
						politicalCell.label.text = @"Political Affinity";
						politicalCell.content.text = [NSString stringWithFormat:@"%@", [self.racialStats objectForKey:@"political_affinity"]];
						cell = politicalCell;
						break;
					case AFFINITY_ROW_RESEARCH:
						; //DO NOT REMOVE
						LETableViewCellLongLabeledText *researchCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
						researchCell.label.text = @"Research Affinity";
						researchCell.content.text = [NSString stringWithFormat:@"%@", [self.racialStats objectForKey:@"research_affinity"]];
						cell = researchCell;
						break;
					case AFFINITY_ROW_SCIENCE:
						; //DO NOT REMOVE
						LETableViewCellLongLabeledText *scienceCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
						scienceCell.label.text = @"Science Affinity";
						scienceCell.content.text = [NSString stringWithFormat:@"%@", [self.racialStats objectForKey:@"science_affinity"]];
						cell = scienceCell;
						break;
					case AFFINITY_ROW_TRADE:
						; //DO NOT REMOVE
						LETableViewCellLongLabeledText *tradeCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
						tradeCell.label.text = @"Trade Affinity";
						tradeCell.content.text = [NSString stringWithFormat:@"%@", [self.racialStats objectForKey:@"trade_affinity"]];
						cell = tradeCell;
						break;
					default:
						cell = nil;
				}
				break;
			default:
				return 0;
				break;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Racial Stats";
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
    [super viewDidUnload];
}


- (void)dealloc {
	self.racialStats = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callback Methods

- (id)viewRacialStatsController:(LEEmpireViewSpeciesStats *)request {
	self.racialStats = request.stats;
	[self.tableView reloadData];
	return nil;
}

#pragma mark -
#pragma mark Class Methods

+ (ViewSpeciesStatsController *)create {
	return [[[ViewSpeciesStatsController alloc] init] autorelease];
}


@end

