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
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellButton.h"
#import "LEBuildingRunExperiment.h"


typedef enum {
	SECTION_PRISONER,
	SECTION_SPECIES,
	SECTION_EXPERIMENTS,
} SECTIONS;

@implementation NewExperimentController


@synthesize geneticsLab;
@synthesize graft;
@synthesize survivalOdds;
@synthesize graftOdds;
@synthesize essentiaCost;
@synthesize selectedAffinity;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Prisoner"], [LEViewSectionTab tableView:self.tableView withText:@"Species"], [LEViewSectionTab tableView:self.tableView withText:@"Experiments"]);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
			return 1;
			break;
		case SECTION_EXPERIMENTS:
			return MAX(1, [[self.graft objectForKey:@"graftable_affinites"] count]);
			break;
		default:
			return 0;
			break;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_PRISONER:
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
			break;
		case SECTION_SPECIES:
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
			break;
		case SECTION_EXPERIMENTS:
			return [LETableViewCellButton getHeightForTableView:tableView];
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
			LETableViewCellLabeledText *spyCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			spyCell.label.text = @"Name";
			spyCell.content.text = [[self.graft objectForKey:@"spy"] objectForKey:@"name"];
			cell = spyCell;
			break;
		case SECTION_SPECIES:
			; //DO NOT REMOVE
			LETableViewCellLabeledText *speciesCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			speciesCell.label.text = @"Name";
			speciesCell.content.text = [[self.graft objectForKey:@"spy"] objectForKey:@"name"];
			cell = speciesCell;
			break;
		case SECTION_EXPERIMENTS:
			; //DO NOT REMOVE
			NSString *affinity = [[self.graft objectForKey:@"graftable_affinities"] objectAtIndex:indexPath.row];
			LETableViewCellButton *selectGraftCell = [LETableViewCellButton getCellForTableView:tableView];
			selectGraftCell.textLabel.text = [Util prettyCodeValue:affinity];
			cell = selectGraftCell;
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
			self.selectedAffinity = [[self.graft objectForKey:@"graftable_affinities"] objectAtIndex:indexPath.row];
			UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Experiment on Prisoner? This will cost %@ essentia, may kill the prisone, and may increase your %@ affinity.", self.essentiaCost, self.selectedAffinity] delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
			actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
			[actionSheet showFromTabBar:self.tabBarController.tabBar];
			[actionSheet release];
			
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
	self.graft = nil;
	self.survivalOdds = nil;
	self.graftOdds = nil;
	self.essentiaCost = nil;
	self.selectedAffinity = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callbacks

- (void)experimentComplete:(LEBuildingRunExperiment *)request {
	if (![request wasError]) {
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Experiment Complete" message:request.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[av show];
		[self.navigationController popViewControllerAnimated:YES];
	}
}


#pragma mark -
#pragma mark UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.destructiveButtonIndex == buttonIndex ) {
		[self.geneticsLab runExperimentWithSpy:[[self.graft objectForKey:@"spy"] objectForKey:@"id"] affinity:self.selectedAffinity target:self callback:@selector(experimentComplete)];
	}
}


#pragma mark -
#pragma mark Class Methods

+ (NewExperimentController *)create {
	return [[[NewExperimentController alloc] init] autorelease];
}


@end

