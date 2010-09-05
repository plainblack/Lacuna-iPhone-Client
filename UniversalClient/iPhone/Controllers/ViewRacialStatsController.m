//
//  ViewRacialStatsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewRacialStatsController.h"
#import "LEMacros.h"
#import "Util.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellLabeledParagraph.h"
#import "LESpeciesViewStats.h"


typedef enum {
	ROW_NAME,
	ROW_DESCRIPTION,
	ROW_HABITABLE_ORBITS,
	ROW_DECEPTION_AFFINITY,
	ROW_ENVIRONMENTAL_AFFINITY,
	ROW_FARMING_AFFINITY,
	ROW_GROWTH_AFFINITY,
	ROW_MANGEMENT_AFFINITY,
	ROW_MANUFACTURING_AFFINITY,
	ROW_MINING_AFFINITY,
	ROW_POLITICAL_AFFINITY,
	ROW_RESEARCH_AFFINITY,
	ROW_SCIENCE_AFFINITY,
	ROW_TRADE_AFFINITY
} ROW;



@implementation ViewRacialStatsController


@synthesize racialStats;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Racial Stats";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}



- (void)viewWillAppear:(BOOL)animated {
	[[[LESpeciesViewStats alloc] initWithCallback:@selector(viewRacialStatsController:) target:self] autorelease];
    [super viewWillAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.racialStats) {
		return 14;
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.racialStats) {
		switch (indexPath.row) {
			case ROW_NAME:
			case ROW_DECEPTION_AFFINITY:
			case ROW_ENVIRONMENTAL_AFFINITY:
			case ROW_FARMING_AFFINITY:
			case ROW_GROWTH_AFFINITY:
			case ROW_HABITABLE_ORBITS:
			case ROW_MANGEMENT_AFFINITY:
			case ROW_MANUFACTURING_AFFINITY:
			case ROW_MINING_AFFINITY:
			case ROW_POLITICAL_AFFINITY:
			case ROW_RESEARCH_AFFINITY:
			case ROW_SCIENCE_AFFINITY:
			case ROW_TRADE_AFFINITY:
				return [LETableViewCellLabeledText getHeightForTableView:tableView];
				break;
			case ROW_DESCRIPTION:
				return [LETableViewCellLabeledParagraph getHeightForTableView:tableView text:[self.racialStats objectForKey:@"description"]];
				break;
			default:
				return 0.0;
		}
	} else {
		return [LETableViewCellLabeledText getHeightForTableView:tableView];
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	
	if (self.racialStats) {
		switch (indexPath.row) {
			case ROW_NAME:
				; //DO NOT REMOVE
				LETableViewCellLabeledText *nameCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				nameCell.label.text = @"Name";
				nameCell.content.text = [self.racialStats objectForKey:@"name"];
				cell = nameCell;
				break;
			case ROW_DESCRIPTION:
				; //DO NOT REMOVE
				LETableViewCellLabeledText *descriptionCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				descriptionCell.label.text = @"Description";
				descriptionCell.content.text = [self.racialStats objectForKey:@"description"];
				cell = descriptionCell;
				break;
			case ROW_HABITABLE_ORBITS:
				; //DO NOT REMOVE
				LETableViewCellLabeledText *habitableOrbitsCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				habitableOrbitsCell.label.text = @"Orbits";
				NSMutableString *orbitValue = nil;
				NSArray *orbits = [self.racialStats objectForKey:@"habitable_orbits"];
				for (id orbit in orbits) {
					if (orbitValue) {
						[orbitValue appendFormat:@", %@", orbit];
					} else {
						orbitValue = [NSMutableString stringWithFormat:@"%@", orbit];
					}
				}
				habitableOrbitsCell.content.text = orbitValue;
				cell = habitableOrbitsCell;
				break;
			case ROW_DECEPTION_AFFINITY:
				; //DO NOT REMOVE
				LETableViewCellLabeledText *deceptionCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				deceptionCell.label.text = @"Deception";
				deceptionCell.content.text = [NSString stringWithFormat:@"%@", [self.racialStats objectForKey:@"deception_affinity"]];
				cell = deceptionCell;
				break;
			case ROW_ENVIRONMENTAL_AFFINITY:
				; //DO NOT REMOVE
				LETableViewCellLabeledText *environmentalCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				environmentalCell.label.text = @"Environmental";
				environmentalCell.content.text = [NSString stringWithFormat:@"%@", [self.racialStats objectForKey:@"environmental_affinity"]];
				cell = environmentalCell;
				break;
			case ROW_FARMING_AFFINITY:
				; //DO NOT REMOVE
				LETableViewCellLabeledText *farmingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				farmingCell.label.text = @"Farming";
				farmingCell.content.text = [NSString stringWithFormat:@"%@", [self.racialStats objectForKey:@"farming_affinity"]];
				cell = farmingCell;
				break;
			case ROW_GROWTH_AFFINITY:
				; //DO NOT REMOVE
				LETableViewCellLabeledText *growthCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				growthCell.label.text = @"Growth";
				growthCell.content.text = [NSString stringWithFormat:@"%@", [self.racialStats objectForKey:@"growth_affinity"]];
				cell = growthCell;
				break;
			case ROW_MANGEMENT_AFFINITY:
				; //DO NOT REMOVE
				LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				loadingCell.label.text = @"Management";
				loadingCell.content.text = [NSString stringWithFormat:@"%@", [self.racialStats objectForKey:@"management_affinity"]];
				cell = loadingCell;
				break;
			case ROW_MANUFACTURING_AFFINITY:
				; //DO NOT REMOVE
				LETableViewCellLabeledText *manufacturingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				manufacturingCell.label.text = @"Manufacturing";
				manufacturingCell.content.text = [NSString stringWithFormat:@"%@", [self.racialStats objectForKey:@"manufacturing_affinity"]];
				cell = manufacturingCell;
				break;
			case ROW_MINING_AFFINITY:
				; //DO NOT REMOVE
				LETableViewCellLabeledText *miningCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				miningCell.label.text = @"Mining";
				miningCell.content.text = [NSString stringWithFormat:@"%@", [self.racialStats objectForKey:@"mining_affinity"]];
				cell = miningCell;
				break;
			case ROW_POLITICAL_AFFINITY:
				; //DO NOT REMOVE
				LETableViewCellLabeledText *politicalCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				politicalCell.label.text = @"Political";
				politicalCell.content.text = [NSString stringWithFormat:@"%@", [self.racialStats objectForKey:@"political_affinity"]];
				cell = politicalCell;
				break;
			case ROW_RESEARCH_AFFINITY:
				; //DO NOT REMOVE
				LETableViewCellLabeledText *researchCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				researchCell.label.text = @"Research";
				researchCell.content.text = [NSString stringWithFormat:@"%@", [self.racialStats objectForKey:@"research_affinity"]];
				cell = researchCell;
				break;
			case ROW_SCIENCE_AFFINITY:
				; //DO NOT REMOVE
				LETableViewCellLabeledText *scienceCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				scienceCell.label.text = @"Science";
				scienceCell.content.text = [NSString stringWithFormat:@"%@", [self.racialStats objectForKey:@"science_affinity"]];
				cell = scienceCell;
				break;
			case ROW_TRADE_AFFINITY:
				; //DO NOT REMOVE
				LETableViewCellLabeledText *tradeCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				tradeCell.label.text = @"Trade";
				tradeCell.content.text = [NSString stringWithFormat:@"%@", [self.racialStats objectForKey:@"trade_affinity"]];
				cell = tradeCell;
				break;
			default:
				cell = nil;
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
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	self.racialStats = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callback Methods

- (id)viewRacialStatsController:(LESpeciesViewStats *)request {
	self.racialStats = request.stats;
	[self.tableView reloadData];
	return nil;
}

#pragma mark -
#pragma mark Class Methods

+ (ViewRacialStatsController *)create {
	return [[[ViewRacialStatsController alloc] init] autorelease];
}


@end

