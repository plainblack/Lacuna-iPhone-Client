//
//  NewExperimentController.m
//  UniversalClient
//
//  Created by Kevin Runde on 12/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "NewExperimentController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "GeneticsLab.h"
#import "PrepareExperiment.h"
#import "Spy.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellLongLabeledText.h"
#import "LETableViewCellLabeledParagraph.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellSpyInfo.h"
#import "LEBuildingRunExperiment.h"


typedef enum {
	SECTION_EXPERIMENTS,
	SECTION_PRISONER,
	SECTION_SPECIES,
} SECTIONS;


typedef enum {
	SPECIES_ROW_NAME,
	SPECIES_ROW_DESCRIPTION,
	SPECIES_ROW_MIN_ORBIT,
	SPECIES_ROW_MAX_ORBIT,
	SPECIES_ROW_DECEPTION,
	SPECIES_ROW_ENVIRONMENTAL,
	SPECIES_ROW_FARMING,
	SPECIES_ROW_GROWTH,
	SPECIES_ROW_MANAGEMENT,
	SPECIES_ROW_MANUFACTURING,
	SPECIES_ROW_MINING,
	SPECIES_ROW_POLITICAL,
	SPECIES_ROW_RESEARCH,
	SPECIES_ROW_SCIENCE,
	SPECIES_ROW_TRADE,
} SPECIES_ROW;

@implementation NewExperimentController


@synthesize geneticsLab;
@synthesize prepareExperiment;
@synthesize graft;
@synthesize selectedAffinity;
@synthesize spy;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.title = @"Pick Affinity";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];

	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Possible Grafts"], [LEViewSectionTab tableView:self.tableView withText:@"Prisoner"], [LEViewSectionTab tableView:self.tableView withText:@"Species"]);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	NSLog(@"Test Subject: %@", self.graft);
	
	Spy *tmpSpy = [[Spy alloc] init];
	[tmpSpy parseData:[self.graft objectForKey:@"spy"]];
	self.spy = tmpSpy;
	[tmpSpy autorelease];
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
		case SECTION_PRISONER:
			return 1;
			break;
		case SECTION_SPECIES:
			return 15;
			break;
		case SECTION_EXPERIMENTS:
			return MAX(1, [[self.graft objectForKey:@"graftable_affinities"] count]);
			break;
		default:
			return 0;
			break;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_PRISONER:
			return [LETableViewCellSpyInfo getHeightForTableView:tableView];
			break;
		case SECTION_SPECIES:
			switch (indexPath.row) {
				case SPECIES_ROW_NAME:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case SPECIES_ROW_DESCRIPTION:
					return [LETableViewCellLabeledParagraph getHeightForTableView:tableView text:[[self.graft objectForKey:@"species"] objectForKey:@"description"]];
					break;
				case SPECIES_ROW_MIN_ORBIT:
				case SPECIES_ROW_MAX_ORBIT:
				case SPECIES_ROW_MANUFACTURING:
				case SPECIES_ROW_DECEPTION:
				case SPECIES_ROW_RESEARCH:
				case SPECIES_ROW_MANAGEMENT:
				case SPECIES_ROW_FARMING:
				case SPECIES_ROW_MINING:
				case SPECIES_ROW_SCIENCE:
				case SPECIES_ROW_ENVIRONMENTAL:
				case SPECIES_ROW_POLITICAL:
				case SPECIES_ROW_TRADE:
				case SPECIES_ROW_GROWTH:
					return [LETableViewCellLongLabeledText getHeightForTableView:tableView];
					break;
				default:
					return 0;
					break;
			}
			break;
		case SECTION_EXPERIMENTS:
			if ([[self.graft objectForKey:@"graftable_affinities"] count] > 0) {
				return [LETableViewCellButton getHeightForTableView:tableView];
			} else {
				return [LETableViewCellLabeledText getHeightForTableView:tableView];
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
		case SECTION_PRISONER:
			; //DO NOT REMOVE
			LETableViewCellSpyInfo *spyCell = [LETableViewCellSpyInfo getCellForTableView:tableView];
			[spyCell setData:self.spy];
			cell = spyCell;
			break;
		case SECTION_SPECIES:
			switch (indexPath.row) {
				case SPECIES_ROW_NAME:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *speciesNameCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					speciesNameCell.label.text = @"Name";
					speciesNameCell.content.text = [[self.graft objectForKey:@"species"] objectForKey:@"name"];
					cell = speciesNameCell;
					break;
				case SPECIES_ROW_DESCRIPTION:
					; //DO NOT REMOVE
					LETableViewCellLabeledParagraph *speciesDescriptionCell = [LETableViewCellLabeledParagraph getCellForTableView:tableView];
					speciesDescriptionCell.label.text = @"Description";
					speciesDescriptionCell.content.text = [[self.graft objectForKey:@"species"] objectForKey:@"description"];
					cell = speciesDescriptionCell;
					break;
				case SPECIES_ROW_MIN_ORBIT:
					; //DO NOT REMOVE
					LETableViewCellLongLabeledText *speciesMinOrbitCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
					speciesMinOrbitCell.label.text = @"Min Orbit";
					speciesMinOrbitCell.content.text = [[self.graft objectForKey:@"species"] objectForKey:@"min_orbit"];
					cell = speciesMinOrbitCell;
					break;
				case SPECIES_ROW_MAX_ORBIT:
					; //DO NOT REMOVE
					LETableViewCellLongLabeledText *speciesMaxOrbitCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
					speciesMaxOrbitCell.label.text = @"Max Orbit";
					speciesMaxOrbitCell.content.text = [[self.graft objectForKey:@"species"] objectForKey:@"max_orbit"];
					cell = speciesMaxOrbitCell;
					break;
				case SPECIES_ROW_MANUFACTURING:
					; //DO NOT REMOVE
					LETableViewCellLongLabeledText *speciesManufacturingCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
					speciesManufacturingCell.label.text = @"Manufacturing";
					speciesManufacturingCell.content.text = [[self.graft objectForKey:@"species"] objectForKey:@"manufacturing_affinity"];
					cell = speciesManufacturingCell;
					break;
				case SPECIES_ROW_DECEPTION:
					; //DO NOT REMOVE
					LETableViewCellLongLabeledText *speciesDeceptionCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
					speciesDeceptionCell.label.text = @"Deception";
					speciesDeceptionCell.content.text = [[self.graft objectForKey:@"species"] objectForKey:@"deception_affinity"];
					cell = speciesDeceptionCell;
					break;
				case SPECIES_ROW_RESEARCH:
					; //DO NOT REMOVE
					LETableViewCellLongLabeledText *speciesResearchCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
					speciesResearchCell.label.text = @"Research";
					speciesResearchCell.content.text = [[self.graft objectForKey:@"species"] objectForKey:@"research_affinity"];
					cell = speciesResearchCell;
					break;
				case SPECIES_ROW_MANAGEMENT:
					; //DO NOT REMOVE
					LETableViewCellLongLabeledText *speciesManagementCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
					speciesManagementCell.label.text = @"Management";
					speciesManagementCell.content.text = [[self.graft objectForKey:@"species"] objectForKey:@"management_affinity"];
					cell = speciesManagementCell;
					break;
				case SPECIES_ROW_FARMING:
					; //DO NOT REMOVE
					LETableViewCellLongLabeledText *speciesFarmingCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
					speciesFarmingCell.label.text = @"Farming";
					speciesFarmingCell.content.text = [[self.graft objectForKey:@"species"] objectForKey:@"farming_affinity"];
					cell = speciesFarmingCell;
					break;
				case SPECIES_ROW_MINING:
					; //DO NOT REMOVE
					LETableViewCellLongLabeledText *speciesMiningCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
					speciesMiningCell.label.text = @"Mining";
					speciesMiningCell.content.text = [[self.graft objectForKey:@"species"] objectForKey:@"mining_affinity"];
					cell = speciesMiningCell;
					break;
				case SPECIES_ROW_SCIENCE:
					; //DO NOT REMOVE
					LETableViewCellLongLabeledText *speciesScienceCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
					speciesScienceCell.label.text = @"Science";
					speciesScienceCell.content.text = [[self.graft objectForKey:@"species"] objectForKey:@"science_affinity"];
					cell = speciesScienceCell;
					break;
				case SPECIES_ROW_ENVIRONMENTAL:
					; //DO NOT REMOVE
					LETableViewCellLongLabeledText *speciesEnvironmentalCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
					speciesEnvironmentalCell.label.text = @"Environmental";
					speciesEnvironmentalCell.content.text = [[self.graft objectForKey:@"species"] objectForKey:@"environmental_affinity"];
					cell = speciesEnvironmentalCell;
					break;
				case SPECIES_ROW_POLITICAL:
					; //DO NOT REMOVE
					LETableViewCellLongLabeledText *speciesPoliticalCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
					speciesPoliticalCell.label.text = @"Political";
					speciesPoliticalCell.content.text = [[self.graft objectForKey:@"species"] objectForKey:@"political_affinity"];
					cell = speciesPoliticalCell;
					break;
				case SPECIES_ROW_TRADE:
					; //DO NOT REMOVE
					LETableViewCellLongLabeledText *speciesTradeCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
					speciesTradeCell.label.text = @"Trade";
					speciesTradeCell.content.text = [[self.graft objectForKey:@"species"] objectForKey:@"trade_affinity"];
					cell = speciesTradeCell;
					break;
				case SPECIES_ROW_GROWTH:
					; //DO NOT REMOVE
					LETableViewCellLongLabeledText *speciesGrowthCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
					speciesGrowthCell.label.text = @"Growth";
					speciesGrowthCell.content.text = [[self.graft objectForKey:@"species"] objectForKey:@"growth_affinity"];
					cell = speciesGrowthCell;
					break;
				default:
					cell = nil;
					break;
			}
			break;
		case SECTION_EXPERIMENTS:
			; //DO NOT REMOVE
			if ([[self.graft objectForKey:@"graftable_affinities"] count] > 0) {
				NSString *affinity = [[self.graft objectForKey:@"graftable_affinities"] objectAtIndex:indexPath.row];
				LETableViewCellButton *selectGraftCell = [LETableViewCellButton getCellForTableView:tableView];
				selectGraftCell.textLabel.text = [Util prettyCodeValue:affinity];
				cell = selectGraftCell;
			} else {
				LETableViewCellLabeledText *noGraftsCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				noGraftsCell.label.text = @"Grafts";
				noGraftsCell.content.text = @"None Available";
				cell = noGraftsCell;
			}

			break;
		default:
			return nil;
			break;
	}

	
    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_EXPERIMENTS:
			if ([[self.graft objectForKey:@"graftable_affinities"] count] > 0) {
				self.selectedAffinity = [[self.graft objectForKey:@"graftable_affinities"] objectAtIndex:indexPath.row];
				
				UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Experiment on Prisoner? This will cost %@ essentia, may kill the prisoner, and may increase your %@.", self.prepareExperiment.essentiaCost, [Util prettyCodeValue:self.selectedAffinity]] message:@"" preferredStyle:UIAlertControllerStyleAlert];
				UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
					[self.geneticsLab runExperimentWithSpy:[[self.graft objectForKey:@"spy"] objectForKey:@"id"] affinity:self.selectedAffinity target:self callback:@selector(experimentComplete:)];
				}];
				UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
				}];
				[alert addAction:cancelAction];
				[alert addAction:okAction];
				[self presentViewController:alert animated:YES completion:nil];
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
    [super viewDidUnload];
}


- (void)dealloc {
	self.geneticsLab = nil;
	self.prepareExperiment = nil;
	self.graft = nil;
	self.selectedAffinity = nil;
	self.spy = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callbacks

- (void)experimentComplete:(LEBuildingRunExperiment *)request {
	if (![request wasError]) {
		[self.prepareExperiment parseData:request.result];
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Experiment Complete" message:request.message preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
		if (request.spySurvived) {
			//[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
			[self.prepareExperiment.grafts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
				NSString *tmpId = [Util idFromDict:[obj objectForKey:@"spy"] named:@"id"];
				if ([tmpId isEqualToString:spy.id]) {
					self.graft = obj;
					*stop = YES;
				}
			}];
			[self.tableView reloadData];
		} else {
			[self.navigationController popViewControllerAnimated:YES];
		}

	}
}


#pragma mark -
#pragma mark Class Methods

+ (NewExperimentController *)create {
	return [[[NewExperimentController alloc] init] autorelease];
}


@end

