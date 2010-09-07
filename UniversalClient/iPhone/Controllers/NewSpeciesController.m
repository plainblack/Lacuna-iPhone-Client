//
//  NewSpeciesController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/11/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "NewSpeciesController.h"
#import "LEMacros.h"
#import "LEViewSectionTab.h"
#import "LESpeciesCreate.h"
#import "LEEmpireFound.h"
#import "Session.h"
#import "LETableViewCellOrbitSelector.h"
#import "LETableViewCellButton.h"
#import "FoundNewEmpireController.h"


typedef enum {
	SECTION_SPECIES,
	SECTION_HABITAL_ORBITS,
	SECTION_AFFINITIES,
	SECTION_CREATE
} SECTION;


typedef enum {
	SPECIES_ROW_NAME,
	SPECIES_ROW_DESCRIPTION
} SPECIES_ROWS;


@interface NewSpeciesController (PrivateMethods)

- (void)calculatePoints;

@end


@implementation NewSpeciesController


@synthesize empireId;
@synthesize username;
@synthesize password;
@synthesize speciesNameCell;
@synthesize speciesDescriptionCell;
@synthesize orbitCells;
@synthesize manufacturingCell;
@synthesize deceptionCell;
@synthesize researchCell;
@synthesize managementCell;
@synthesize farmingCell;
@synthesize miningCell;
@synthesize scienceCell;
@synthesize environmentalCell;
@synthesize politicalCell;
@synthesize tradeCell;
@synthesize growthCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
	
	//Setup Cells
	self.speciesNameCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.speciesNameCell.label.text = @"Name";
	self.speciesNameCell.delegate = self;
	
	self.speciesDescriptionCell = [LETableViewCellLabeledTextView getCellForTableView:self.tableView];
	self.speciesDescriptionCell.label.text = @"Description";
	
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:NUM_ORBITS];
	for (int index=0; index<NUM_ORBITS; index++) {
		LETableViewCellOrbitSelector *orbitCell = [LETableViewCellOrbitSelector getCellForTableView:self.tableView];
		orbitCell.label.text = [NSString stringWithFormat:@"Orbit %i", index+1];
		orbitCell.pointsDelegate = self;
		[tmp addObject:orbitCell];
	}
	self.orbitCells = tmp;
	
	self.manufacturingCell = [LETableViewCellAffinitySelector getCellForTableView:self.tableView];
	self.manufacturingCell.nameLabel.text = @"Manufacturing";
	self.manufacturingCell.pointsDelegate = self;
	[self.manufacturingCell setRating:3];
	
	self.deceptionCell = [LETableViewCellAffinitySelector getCellForTableView:self.tableView];
	self.deceptionCell.nameLabel.text = @"Deception";
	self.deceptionCell.pointsDelegate = self;
	[self.deceptionCell setRating:3];
	
	self.researchCell = [LETableViewCellAffinitySelector getCellForTableView:self.tableView];
	self.researchCell.nameLabel.text = @"Research";
	self.researchCell.pointsDelegate = self;
	[self.researchCell setRating:3];
	
	self.managementCell = [LETableViewCellAffinitySelector getCellForTableView:self.tableView];
	self.managementCell.nameLabel.text = @"Management";
	self.managementCell.pointsDelegate = self;
	[self.managementCell setRating:3];
	
	self.farmingCell = [LETableViewCellAffinitySelector getCellForTableView:self.tableView];
	self.farmingCell.nameLabel.text = @"Farming";
	self.farmingCell.pointsDelegate = self;
	[self.farmingCell setRating:3];
	
	self.miningCell = [LETableViewCellAffinitySelector getCellForTableView:self.tableView];
	self.miningCell.nameLabel.text = @"Mining";
	self.miningCell.pointsDelegate = self;
	[self.miningCell setRating:3];
	
	self.scienceCell = [LETableViewCellAffinitySelector getCellForTableView:self.tableView];
	self.scienceCell.nameLabel.text = @"Science";
	self.scienceCell.pointsDelegate = self;
	[self.scienceCell setRating:3];
	
	self.environmentalCell = [LETableViewCellAffinitySelector getCellForTableView:self.tableView];
	self.environmentalCell.nameLabel.text = @"Environmental";
	self.environmentalCell.pointsDelegate = self;
	[self.environmentalCell setRating:3];
	
	self.politicalCell = [LETableViewCellAffinitySelector getCellForTableView:self.tableView];
	self.politicalCell.nameLabel.text = @"Political";
	self.politicalCell.pointsDelegate = self;
	[self.politicalCell setRating:3];
	
	self.tradeCell = [LETableViewCellAffinitySelector getCellForTableView:self.tableView];
	self.tradeCell.nameLabel.text = @"Trade";
	self.tradeCell.pointsDelegate = self;
	[self.tradeCell setRating:3];
	
	self.growthCell = [LETableViewCellAffinitySelector getCellForTableView:self.tableView];
	self.growthCell.nameLabel.text = @"Growth";
	self.growthCell.pointsDelegate = self;
	[self.growthCell setRating:3];
	
	[self calculatePoints];
	self.navigationItem.title = [NSString stringWithFormat:@"%i / 45 points", self->points];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Species"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Habital Orbits"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Affinities"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Create Species"]);
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case SECTION_SPECIES:
			return 2;
			break;
		case SECTION_HABITAL_ORBITS:
			return [orbitCells count];
			break;
		case SECTION_AFFINITIES:
			return 11;
			break;
		case SECTION_CREATE:
			return 1;
			break;
		default:
			return 0;
			break;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_SPECIES:
			switch (indexPath.row) {
				case SPECIES_ROW_NAME:
					return [LETableViewCellTextEntry getHeightForTableView:tableView];
					break;
				case SPECIES_ROW_DESCRIPTION:
					return [LETableViewCellLabeledTextView getHeightForTableView:tableView];
					break;
				default:
					return 0;
					break;
			}
			break;
		case SECTION_HABITAL_ORBITS:
			return [LETableViewCellOrbitSelector getHeightForTableView:tableView];
			break;
		case SECTION_AFFINITIES:
			return [LETableViewCellAffinitySelector getHeightForTableView:tableView];
			break;
		case SECTION_CREATE:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		default:
			return 0;
			break;
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	
	switch (indexPath.section) {
		case SECTION_SPECIES:
			switch (indexPath.row) {
				case SPECIES_ROW_NAME:
					cell = self.speciesNameCell;
					break;
				case SPECIES_ROW_DESCRIPTION:
					cell = self.speciesDescriptionCell;
					break;
				default:
					cell = nil;
					break;
			}
			break;
		case SECTION_HABITAL_ORBITS:
			cell = [orbitCells objectAtIndex:indexPath.row];
			break;
		case SECTION_AFFINITIES:
			switch (indexPath.row) {
				case 0:
					cell = manufacturingCell;
					break;
				case 1:
					cell = deceptionCell;
					break;
				case 2:
					cell = researchCell;
					break;
				case 3:
					cell = managementCell;
					break;
				case 4:
					cell = farmingCell;
					break;
				case 5:
					cell = miningCell;
					break;
				case 6:
					cell = scienceCell;
					break;
				case 7:
					cell = environmentalCell;
					break;
				case 8:
					cell = politicalCell;
					break;
				case 9:
					cell = tradeCell;
					break;
				case 10:
					cell = growthCell;
					break;
				default:
					break;
			}
			break;
		case SECTION_CREATE:
			; //DO NOT REMOVE
			LETableViewCellButton *createButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			createButtonCell.textLabel.text = @"Create";
			cell = createButtonCell;
			break;
		default:
			cell = nil;
			break;
	}

    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.pendingRequest) {
		if (indexPath.section == SECTION_CREATE) {
			[self createSpecies];
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    self.speciesNameCell = nil;
	self.speciesDescriptionCell = nil;
	self.orbitCells = nil;
	self.manufacturingCell = nil;
	self.deceptionCell = nil;
	self.researchCell = nil;
	self.managementCell = nil;
	self.farmingCell = nil;
	self.miningCell = nil;
	self.scienceCell = nil;
	self.environmentalCell = nil;
	self.politicalCell = nil;
	self.tradeCell = nil;
	self.growthCell = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	self.empireId = nil;
	self.username = nil;
	self.password = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance methods

- (IBAction)createSpecies {
	if (self->points > 45) {
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Too many points" message:[NSString stringWithFormat:@"You have spent %i points, but you can only spend 45 points.", self->points] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[av show];
	} else if (self->points < 45) {
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Too few points" message:[NSString stringWithFormat:@"You have spent %i points, but you must spend 45 points.", self->points] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[av show];
		
	} else {
		NSMutableArray *orbitArray = [NSMutableArray arrayWithCapacity: NUM_ORBITS];
		for (int index=0; index<NUM_ORBITS; index++) {
			LETableViewCellOrbitSelector *cell = [orbitCells objectAtIndex:index];
			if ([cell isSelected]) {
				[orbitArray addObject:[NSDecimalNumber numberWithInteger:(index+1)]];
			}
		}
		self.pendingRequest = YES;
		[[[LESpeciesCreate alloc] initWithCallback:@selector(speciesCreated:) target:self
										  empireId:self.empireId
											  name:self.speciesNameCell.textField.text
									   description:self.speciesDescriptionCell.textView.text
								   habitableOrbits:orbitArray
							 manufacturingAffinity:manufacturingCell.rating
								 deceptionAffinity:deceptionCell.rating
								  researchAffinity:researchCell.rating
								managementAffinity:managementCell.rating
								   farmingAffinity:farmingCell.rating
									miningAffinity:miningCell.rating
								   scienceAffinity:scienceCell.rating
							 environmentalAffinity:environmentalCell.rating
								 politicalAffinity:politicalCell.rating
									 tradeAffinity:tradeCell.rating
									growthAffinity:growthCell.rating] autorelease];
	}
}


#pragma mark -
#pragma mark LESpeciesUpdatePointsDelegate

- (void)updatePoints:(NSInteger)delta {
	//points += delta;
	[self calculatePoints];
	self.navigationItem.title = [NSString stringWithFormat:@"%i / 45 points", self->points];
}


#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.speciesNameCell.textField) {
		[self.speciesNameCell resignFirstResponder];
	}
	
	return YES;
}


#pragma mark -
#pragma mark Instance Methods

- (IBAction)cancel {
	[self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark PrivateMethods

- (void)calculatePoints {
	NSInteger newPoints = 0;
	for (LETableViewCellOrbitSelector *orbitCell in self.orbitCells) {
		if([orbitCell isSelected]) {
			newPoints++;
		}
	}
	newPoints += _intv([self.manufacturingCell rating]);
	newPoints += _intv([self.deceptionCell rating]);
	newPoints += _intv([self.researchCell rating]);
	newPoints += _intv([self.managementCell rating]);
	newPoints += _intv([self.farmingCell rating]);
	newPoints += _intv([self.miningCell rating]);
	newPoints += _intv([self.scienceCell rating]);
	newPoints += _intv([self.environmentalCell rating]);
	newPoints += _intv([self.politicalCell rating]);
	newPoints += _intv([self.tradeCell rating]);
	newPoints += _intv([self.growthCell rating]);
	self->points = newPoints;
}


#pragma mark -
#pragma mark Callbacks

- (id)speciesCreated:(LESpeciesCreate *) request {
	self.pendingRequest = NO;
	if ([request wasError]) {
		switch ([request errorCode]) {
			case 1009:
				; //DO NOT REMOVE
				[request markErrorHandled];
				UIAlertView *nameAlertView = [[[UIAlertView alloc] initWithTitle:@"Could not create species" message:@"Your selected orbits must be continuous. You cannot have a break within the list of habital orbits." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
				[nameAlertView show];
				break;
		}
	} else {
		FoundNewEmpireController *foundNewEmpireController = [FoundNewEmpireController create];
		foundNewEmpireController.empireId = self.empireId;
		foundNewEmpireController.username = self.username;
		foundNewEmpireController.password = self.password;
		[self.navigationController pushViewController:foundNewEmpireController animated:YES];
	}
	
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (NewSpeciesController *) create {
	return [[[NewSpeciesController alloc] init] autorelease];
}


@end

