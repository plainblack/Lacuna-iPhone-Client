//
//  EditSpeciesController.m
//  UniversalClient
//
//  Created by Kevin Runde on 12/20/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "EditSpeciesController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellParagraph.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellLabeledIconText.h"
#import "LEEmpireUpdateSpecies.h"
#import "LEEmpireRedefineSpeciesLimits.h"
#import "LEEmpireRedefineSpecies.h"


typedef enum {
	SECTION_REDEFINE,
	SECTION_SPECIES,
	SECTION_HABITAL_ORBITS,
	SECTION_AFFINITIES,
} SECTION;


typedef enum {
	REDEFINE_ROWS_CAN,
	REDEFINE_ROWS_COST,
	REDEFINE_ROWS_ORBIT_MIN,
	REDEFINE_ROWS_ORBIT_MAX,
	REDEFINE_ROWS_GROWTH_MIN,
} REDEFINE_ROWS;

typedef enum {
	SPECIES_ROW_NAME,
	SPECIES_ROW_DESCRIPTION
} SPECIES_ROWS;


typedef enum {
	ORBIT_ROW_MIN,
	ORBIT_ROW_MAX
} ORBIT_ROWS;


@interface EditSpeciesController (PrivateMethods)

- (void)calculatePoints;

@end




@implementation EditSpeciesController


@synthesize canRedefine;
@synthesize redefineCost;
@synthesize orbitMin;
@synthesize orbitMax;
@synthesize growthMin;
@synthesize redefineReason;
@synthesize racialStats;
@synthesize speciesNameCell;
@synthesize speciesDescriptionCell;
@synthesize minOrbitCell;
@synthesize maxOrbitCell;
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
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(redefineSpecies)] autorelease];
	
	//Setup Cells
	self.speciesNameCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.speciesNameCell.label.text = @"Name";
	self.speciesNameCell.delegate = self;
	self.speciesNameCell.textField.text = [self.racialStats objectForKey:@"name"];
	
	self.speciesDescriptionCell = [LETableViewCellLabeledTextView getCellForTableView:self.tableView];
	self.speciesDescriptionCell.label.text = @"Description";
	self.speciesDescriptionCell.textView.text = [self.racialStats objectForKey:@"description"];
	
	self.minOrbitCell = [LETableViewCellOrbitSelectorV2 getCellForTableView:self.tableView];
	self.minOrbitCell.nameLabel.text = @"Minimum Orbit";
	self.minOrbitCell.pointsDelegate = self;
	self.minOrbitCell.viewController = self;
	[self.minOrbitCell setRating:_intv([self.racialStats objectForKey:@"min_orbit"])];
	
	self.maxOrbitCell = [LETableViewCellOrbitSelectorV2 getCellForTableView:self.tableView];
	self.maxOrbitCell.nameLabel.text = @"Maximum Orbit";
	self.maxOrbitCell.pointsDelegate = self;
	self.maxOrbitCell.viewController = self;
	[self.maxOrbitCell setRating:_intv([self.racialStats objectForKey:@"max_orbit"])];
	
	self.manufacturingCell = [LETableViewCellAffinitySelectorV2 getCellForTableView:self.tableView];
	self.manufacturingCell.nameLabel.text = @"Manufacturing";
	self.manufacturingCell.pointsDelegate = self;
	self.manufacturingCell.viewController = self;
	[self.manufacturingCell setRating:_intv([self.racialStats objectForKey:@"manufacturing_affinity"])];
	
	self.deceptionCell = [LETableViewCellAffinitySelectorV2 getCellForTableView:self.tableView];
	self.deceptionCell.nameLabel.text = @"Deception";
	self.deceptionCell.pointsDelegate = self;
	self.deceptionCell.viewController = self;
	[self.deceptionCell setRating:_intv([self.racialStats objectForKey:@"deception_affinity"])];
	
	self.researchCell = [LETableViewCellAffinitySelectorV2 getCellForTableView:self.tableView];
	self.researchCell.nameLabel.text = @"Research";
	self.researchCell.pointsDelegate = self;
	self.researchCell.viewController = self;
	[self.researchCell setRating:_intv([self.racialStats objectForKey:@"research_affinity"])];
	
	self.managementCell = [LETableViewCellAffinitySelectorV2 getCellForTableView:self.tableView];
	self.managementCell.nameLabel.text = @"Management";
	self.managementCell.pointsDelegate = self;
	self.managementCell.viewController = self;
	[self.managementCell setRating:_intv([self.racialStats objectForKey:@"management_affinity"])];
	
	self.farmingCell = [LETableViewCellAffinitySelectorV2 getCellForTableView:self.tableView];
	self.farmingCell.nameLabel.text = @"Farming";
	self.farmingCell.pointsDelegate = self;
	self.farmingCell.viewController = self;
	[self.farmingCell setRating:_intv([self.racialStats objectForKey:@"farming_affinity"])];
	
	self.miningCell = [LETableViewCellAffinitySelectorV2 getCellForTableView:self.tableView];
	self.miningCell.nameLabel.text = @"Mining";
	self.miningCell.pointsDelegate = self;
	self.miningCell.viewController = self;
	[self.miningCell setRating:_intv([self.racialStats objectForKey:@"mining_affinity"])];
	
	self.scienceCell = [LETableViewCellAffinitySelectorV2 getCellForTableView:self.tableView];
	self.scienceCell.nameLabel.text = @"Science";
	self.scienceCell.pointsDelegate = self;
	self.scienceCell.viewController = self;
	[self.scienceCell setRating:_intv([self.racialStats objectForKey:@"science_affinity"])];
	
	self.environmentalCell = [LETableViewCellAffinitySelectorV2 getCellForTableView:self.tableView];
	self.environmentalCell.nameLabel.text = @"Environmental";
	self.environmentalCell.pointsDelegate = self;
	self.environmentalCell.viewController = self;
	[self.environmentalCell setRating:_intv([self.racialStats objectForKey:@"environmental_affinity"])];
	
	self.politicalCell = [LETableViewCellAffinitySelectorV2 getCellForTableView:self.tableView];
	self.politicalCell.nameLabel.text = @"Political";
	self.politicalCell.pointsDelegate = self;
	self.politicalCell.viewController = self;
	[self.politicalCell setRating:_intv([self.racialStats objectForKey:@"political_affinity"])];
	
	self.tradeCell = [LETableViewCellAffinitySelectorV2 getCellForTableView:self.tableView];
	self.tradeCell.nameLabel.text = @"Trade";
	self.tradeCell.pointsDelegate = self;
	self.tradeCell.viewController = self;
	[self.tradeCell setRating:_intv([self.racialStats objectForKey:@"trade_affinity"])];
	
	self.growthCell = [LETableViewCellAffinitySelectorV2 getCellForTableView:self.tableView];
	self.growthCell.nameLabel.text = @"Growth";
	self.growthCell.pointsDelegate = self;
	self.growthCell.viewController = self;
	[self.growthCell setRating:_intv([self.racialStats objectForKey:@"growth_affinity"])];
	
	[self calculatePoints];
	self.navigationItem.title = [NSString stringWithFormat:@"%i / 45 points", self->points];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Redefine Info"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Species"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Habital Orbits"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Affinities"]);
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	if (self.redefineReason == nil) {
		[[[LEEmpireRedefineSpeciesLimits alloc] initWithCallback:@selector(loadedSpeciesLimits:) target:self] autorelease];
	}
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.redefineReason) {
		return 4;
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.redefineReason) {
		switch (section) {
			case SECTION_REDEFINE:
				return 5;
				break;
			case SECTION_SPECIES:
				return 2;
				break;
			case SECTION_HABITAL_ORBITS:
				return 2;
				break;
			case SECTION_AFFINITIES:
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
	if (self.redefineReason) {
		switch (indexPath.section) {
			case SECTION_REDEFINE:
				switch (indexPath.row) {
					case REDEFINE_ROWS_CAN:
						return [LETableViewCellParagraph getHeightForTableView:tableView text:self.redefineReason];
						break;
					case REDEFINE_ROWS_COST:
						return [LETableViewCellLabeledIconText getHeightForTableView:tableView];
						break;
					case REDEFINE_ROWS_ORBIT_MIN:
					case REDEFINE_ROWS_ORBIT_MAX:
					case REDEFINE_ROWS_GROWTH_MIN:
						return [LETableViewCellLabeledText getHeightForTableView:tableView];
						break;
					default:
						return 0;
						break;
				}
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
			case SECTION_AFFINITIES:
				return [LETableViewCellAffinitySelectorV2 getHeightForTableView:tableView];
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
	UITableViewCell *cell = nil;
	
	if (self.redefineReason) {
		switch (indexPath.section) {
			case SECTION_REDEFINE:
				switch (indexPath.row) {
					case REDEFINE_ROWS_CAN:
						; //DO NOT REMOVE
						LETableViewCellParagraph *canCell = [LETableViewCellParagraph getCellForTableView:tableView];
						canCell.content.text = self.redefineReason;
						cell = canCell;
						break;
					case REDEFINE_ROWS_COST:
						; //DO NOT REMOVE
						LETableViewCellLabeledIconText *costCell = [LETableViewCellLabeledIconText getCellForTableView:tableView isSelectable:NO];
						costCell.label.text = @"Cost";
						costCell.icon.image = ESSENTIA_ICON;
						costCell.content.text = [Util prettyNSDecimalNumber:self.redefineCost];
						cell = costCell;
						break;
					case REDEFINE_ROWS_ORBIT_MIN:
						; //DO NOT REMOVE
						LETableViewCellLabeledText *orbitMinCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
						orbitMinCell.label.text = @"Orbit Min";
						orbitMinCell.content.text = [Util prettyNSDecimalNumber:self.orbitMin];
						cell = orbitMinCell;
						break;
					case REDEFINE_ROWS_ORBIT_MAX:
						; //DO NOT REMOVE
						LETableViewCellLabeledText *orbitMaxCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
						orbitMaxCell.label.text = @"Orbit Max";
						orbitMaxCell.content.text = [Util prettyNSDecimalNumber:self.orbitMax];
						cell = orbitMaxCell;
						break;
					case REDEFINE_ROWS_GROWTH_MIN:
						; //DO NOT REMOVE
						LETableViewCellLabeledText *growthMinCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
						growthMinCell.label.text = @"Growth Min";
						growthMinCell.content.text = [Util prettyNSDecimalNumber:self.growthMin];
						cell = growthMinCell;
						break;
					default:
						cell = nil;
						break;
				}
				break;
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
				switch (indexPath.row) {
					case ORBIT_ROW_MIN:
						cell = self.minOrbitCell;
						break;
					case ORBIT_ROW_MAX:
						cell = self.maxOrbitCell;
						break;
					default:
						break;
				}
				break;
			case SECTION_AFFINITIES:
				switch (indexPath.row) {
					case 0:
						cell = deceptionCell;
						break;
					case 1:
						cell = environmentalCell;
						break;
					case 2:
						cell = farmingCell;
						break;
					case 3:
						cell = growthCell;
						break;
					case 4:
						cell = managementCell;
						break;
					case 5:
						cell = manufacturingCell;
						break;
					case 6:
						cell = miningCell;
						break;
					case 7:
						cell = politicalCell;
						break;
					case 8:
						cell = researchCell;
						break;
					case 9:
						cell = scienceCell;
						break;
					case 10:
						cell = tradeCell;
						break;
					default:
						break;
				}
				break;
			default:
				cell = nil;
				break;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Limts";
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
    self.speciesNameCell = nil;
	self.speciesDescriptionCell = nil;
	self.minOrbitCell = nil;
	self.maxOrbitCell = nil;
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
    self.speciesNameCell = nil;
	self.speciesDescriptionCell = nil;
	self.minOrbitCell = nil;
	self.maxOrbitCell = nil;
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
	self.redefineCost = nil;
	self.orbitMin = nil;
	self.orbitMax = nil;
	self.growthMin = nil;
	self.redefineReason = nil;
	self.racialStats = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance methods

- (IBAction)redefineSpecies {
	if (_intv(self.maxOrbitCell.rating) < _intv(self.minOrbitCell.rating)) {
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Invalid Orbits" message: @"Max Orbit must be greater than or equal to min orbit." preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
	} else if (self->points > 45) {
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Too many points" message:[NSString stringWithFormat:@"You have spent %i points, but you can only spend 45 points.", self->points] preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
	} else if (self->points < 45) {
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Too few points" message:[NSString stringWithFormat:@"You have spent %i points, but you must spend 45 points.", self->points] preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
	} else if ([self.orbitMin compare:self.minOrbitCell.rating] == NSOrderedAscending) {
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Min Orbit too high" message:[NSString stringWithFormat:@"Your Min Orbit cannot go above %@.", self.orbitMin] preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
	} else if ([self.orbitMax compare:self.maxOrbitCell.rating] == NSOrderedDescending) {
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Max Orbit too low" message:[NSString stringWithFormat:@"Your Max Orbit cannot go below %@.", self.orbitMax] preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
	} else if ([self.growthMin compare:self.growthCell.rating] == NSOrderedDescending) {
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Growth too low" message:[NSString stringWithFormat:@"Your Growth cannot go below %@.", self.growthMin] preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
	} else {
		self.pendingRequest = YES;
		[[[LEEmpireRedefineSpecies alloc] initWithCallback:@selector(redefinedSpecies:)
													target:self
													  name:self.speciesNameCell.textField.text
											   description:self.speciesDescriptionCell.textView.text
												  minOrbit:self.minOrbitCell.rating
												  maxOrbit:self.maxOrbitCell.rating
									 manufacturingAffinity:self.manufacturingCell.rating
										 deceptionAffinity:self.deceptionCell.rating
										  researchAffinity:self.researchCell.rating
										managementAffinity:self.managementCell.rating
										   farmingAffinity:self.farmingCell.rating
											miningAffinity:self.miningCell.rating
										   scienceAffinity:self.scienceCell.rating
									 environmentalAffinity:self.environmentalCell.rating
										 politicalAffinity:self.politicalCell.rating
											 tradeAffinity:self.tradeCell.rating
											growthAffinity:self.growthCell.rating] autorelease];
	}
}


#pragma mark -
#pragma mark LESpeciesUpdatePointsDelegate

- (void)updatePoints {
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
#pragma mark PrivateMethods

- (void)calculatePoints {
	
	NSInteger newPoints = _intv(self.maxOrbitCell.rating) - _intv(self.minOrbitCell.rating) + 1;
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

- (void)loadedSpeciesLimits:(LEEmpireRedefineSpeciesLimits *) request {
	self.redefineCost = request.essentiaCost;
	self.orbitMin = request.minOrbit;
	self.orbitMax = request.maxOrbit;
	self.growthMin = request.minGrowth;
	self.canRedefine = request.can;
	if (request.can) {
		self.redefineReason = @"You may redefine your species stats for the cost listed below. Changing your species affinities is risky business and will affect the game in many ways you cannot foresee. In addition, you can only change your affinities once per month. Use at your own risk!";
	} else {
		self.redefineReason = request.reason;
	}
	[self.tableView reloadData];
}


- (void)redefinedSpecies:(LEEmpireRedefineSpecies *) request {
	self.pendingRequest = NO;
	if (![request wasError]) {
		[self.navigationController popViewControllerAnimated:YES];
	}
}


#pragma mark -
#pragma mark Class Methods

+ (EditSpeciesController *) create {
	return [[[EditSpeciesController alloc] init] autorelease];
}


@end

