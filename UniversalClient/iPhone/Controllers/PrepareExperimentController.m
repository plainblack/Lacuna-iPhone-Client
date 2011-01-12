//
//  PrepareExperimentController.m
//  UniversalClient
//
//  Created by Kevin Runde on 12/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "PrepareExperimentController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "GeneticsLab.h"
#import "PrepareExperiment.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellLabeledIconText.h"
#import "LETableViewCellButton.h"
#import "LEBuildingPrepareExperiment.h"
#import "NewExperimentController.h"


typedef enum {
	SECTION_DETAILS,
	SECTION_PRISONERS,
} SECTIONS;


typedef enum {
	DETAIL_ROW_SURVIVAL_ODDS,
	DETAIL_ROW_GRAFT_ODDS,
	DETAIL_ROW_ESSENTIA_COST,
} DETAIL_ROWS;


@implementation PrepareExperimentController


@synthesize geneticsLab;
@synthesize prepareExperiment;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.title = @"Pick Subject";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];

	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Details"], [LEViewSectionTab tableView:self.tableView withText:@"Prisoners"]);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	if (!self.prepareExperiment) {
		[self.geneticsLab prepareExperiments:self callback:@selector(experimentsPrepared:)];
	} else {
		[self.tableView reloadData];
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
	return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case SECTION_PRISONERS:
			return MAX(1, [self.prepareExperiment.grafts count]);
			break;
		case SECTION_DETAILS:
			return 3;
			break;
		default:
			return 0;
			break;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_PRISONERS:
			if (self.prepareExperiment.grafts) {
				return [LETableViewCellButton getHeightForTableView:tableView];
			} else {
				return [LETableViewCellLabeledText getHeightForTableView:tableView];
			}
			break;
		case SECTION_DETAILS:
			switch (indexPath.row) {
				case DETAIL_ROW_SURVIVAL_ODDS:
				case DETAIL_ROW_GRAFT_ODDS:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case DETAIL_ROW_ESSENTIA_COST:
					return [LETableViewCellLabeledIconText getHeightForTableView:tableView];
					break;
				default:
					return 0;
					break;
			}
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
		case SECTION_PRISONERS:
			if (self.prepareExperiment.grafts) {
				if ([self.prepareExperiment.grafts count] > 0) {
					NSMutableDictionary *graft = [self.prepareExperiment.grafts objectAtIndex:indexPath.row];
					LETableViewCellButton *selectGraftCell = [LETableViewCellButton getCellForTableView:tableView];
					selectGraftCell.textLabel.text = [[graft objectForKey:@"spy"] objectForKey:@"name"];
					cell = selectGraftCell;
				} else {
					LETableViewCellLabeledText *noneCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					noneCell.label.text = @"Prisoners";
					noneCell.content.text = @"None";
					cell = noneCell;
				}
				
			} else {
				LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				loadingCell.label.text = @"Prisoners";
				loadingCell.content.text = @"Loading";
				cell = loadingCell;
			}
			break;
		case SECTION_DETAILS:
			switch (indexPath.row) {
				case DETAIL_ROW_SURVIVAL_ODDS:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *survivalOddsCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					survivalOddsCell.label.text = @"Survival";
					if (self.prepareExperiment.survivalOdds) {
						survivalOddsCell.content.text = [NSString stringWithFormat:@"%@%%", self.prepareExperiment.survivalOdds];
					} else {
						survivalOddsCell.content.text = @"Loading";
					}
					cell = survivalOddsCell;
					break;
				case DETAIL_ROW_GRAFT_ODDS:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *graftOddsCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					graftOddsCell.label.text = @"Graft";
					if (self.prepareExperiment.graftOdds) {
						graftOddsCell.content.text = [NSString stringWithFormat:@"%@%%", self.prepareExperiment.graftOdds];
					} else {
						graftOddsCell.content.text = @"Loading";
					}
					cell = graftOddsCell;
					break;
				case DETAIL_ROW_ESSENTIA_COST:
					; //DO NOT REMOVE
					LETableViewCellLabeledIconText *essentiaCostCell = [LETableViewCellLabeledIconText getCellForTableView:tableView isSelectable:NO];
					essentiaCostCell.label.text = @"Cost";
					essentiaCostCell.icon.image = ESSENTIA_ICON;
					if (self.prepareExperiment.survivalOdds) {
						essentiaCostCell.content.text = [Util prettyNSDecimalNumber:self.prepareExperiment.essentiaCost];
					} else {
						essentiaCostCell.content.text = @"Loading";
					}
					cell = essentiaCostCell;
					break;
				default:
					cell = nil;
					break;
			}
			break;
		default:
			return 0;
			break;
	}
	
	
    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == SECTION_PRISONERS) {
		if ([self.prepareExperiment.grafts count] > 0) {
			NSMutableDictionary *graft = [self.prepareExperiment.grafts objectAtIndex:indexPath.row];
			NewExperimentController *newExperimentController = [NewExperimentController create];
			newExperimentController.geneticsLab = self.geneticsLab;
			newExperimentController.prepareExperiment = self.prepareExperiment;
			newExperimentController.graft = graft;
			[self.navigationController pushViewController:newExperimentController animated:YES];
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
    [super viewDidUnload];
}


- (void)dealloc {
	self.geneticsLab = nil;
	self.prepareExperiment = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callbacks

- (void)experimentsPrepared:(LEBuildingPrepareExperiment *)request {
	if (![request wasError]) {
		if (!self.prepareExperiment) {
			PrepareExperiment *tmp = [[PrepareExperiment alloc] init];
			self.prepareExperiment = tmp;
			[tmp release];
		}
		[self.prepareExperiment parseData:request.result];
		[self.tableView reloadData];
	}
}


#pragma mark -
#pragma mark Class Methods

+ (PrepareExperimentController *)create {
	return [[[PrepareExperimentController alloc] init] autorelease];
}


@end

