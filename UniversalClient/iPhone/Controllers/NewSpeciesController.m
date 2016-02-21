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
#import "LEEmpireUpdateSpecies.h"
#import "Session.h"
#import "LETableViewCellButton.h"
#import "LEEmpireFound.h"


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


typedef enum {
	ORBIT_ROW_MIN,
	ORBIT_ROW_MAX
} ORBIT_ROWS;


@interface NewSpeciesController (PrivateMethods)

- (void)calculatePoints;

@end


@implementation NewSpeciesController


@synthesize empireId;
@synthesize username;
@synthesize password;
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
@synthesize speciesTemplate;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	//Setup Cells
	self.speciesNameCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.speciesNameCell.label.text = @"Name";
	self.speciesNameCell.delegate = self;
	self.speciesNameCell.textField.text = [self.speciesTemplate objectForKey:@"name"];
	
	self.speciesDescriptionCell = [LETableViewCellLabeledTextView getCellForTableView:self.tableView];
	self.speciesDescriptionCell.label.text = @"Description";
	self.speciesDescriptionCell.textView.text = [self.speciesTemplate objectForKey:@"description"];
	
	self.minOrbitCell = [LETableViewCellOrbitSelectorV2 getCellForTableView:self.tableView];
	self.minOrbitCell.nameLabel.text = @"Minimum Orbit";
	self.minOrbitCell.pointsDelegate = self;
	self.minOrbitCell.viewController = self;
	[self.minOrbitCell setRating:_intv([self.speciesTemplate objectForKey:@"min_orbit"])];
	
	self.maxOrbitCell = [LETableViewCellOrbitSelectorV2 getCellForTableView:self.tableView];
	self.maxOrbitCell.nameLabel.text = @"Maximum Orbit";
	self.maxOrbitCell.pointsDelegate = self;
	self.maxOrbitCell.viewController = self;
	[self.maxOrbitCell setRating:_intv([self.speciesTemplate objectForKey:@"max_orbit"])];
	
	self.manufacturingCell = [LETableViewCellAffinitySelectorV2 getCellForTableView:self.tableView];
	self.manufacturingCell.nameLabel.text = @"Manufacturing";
	self.manufacturingCell.pointsDelegate = self;
	self.manufacturingCell.viewController = self;
	[self.manufacturingCell setRating:_intv([self.speciesTemplate objectForKey:@"manufacturing_affinity"])];
	
	self.deceptionCell = [LETableViewCellAffinitySelectorV2 getCellForTableView:self.tableView];
	self.deceptionCell.nameLabel.text = @"Deception";
	self.deceptionCell.pointsDelegate = self;
	self.deceptionCell.viewController = self;
	[self.deceptionCell setRating:_intv([self.speciesTemplate objectForKey:@"deception_affinity"])];
	
	self.researchCell = [LETableViewCellAffinitySelectorV2 getCellForTableView:self.tableView];
	self.researchCell.nameLabel.text = @"Research";
	self.researchCell.pointsDelegate = self;
	self.researchCell.viewController = self;
	[self.researchCell setRating:_intv([self.speciesTemplate objectForKey:@"research_affinity"])];
	
	self.managementCell = [LETableViewCellAffinitySelectorV2 getCellForTableView:self.tableView];
	self.managementCell.nameLabel.text = @"Management";
	self.managementCell.pointsDelegate = self;
	self.managementCell.viewController = self;
	[self.managementCell setRating:_intv([self.speciesTemplate objectForKey:@"management_affinity"])];
	
	self.farmingCell = [LETableViewCellAffinitySelectorV2 getCellForTableView:self.tableView];
	self.farmingCell.nameLabel.text = @"Farming";
	self.farmingCell.pointsDelegate = self;
	self.farmingCell.viewController = self;
	[self.farmingCell setRating:_intv([self.speciesTemplate objectForKey:@"farming_affinity"])];
	
	self.miningCell = [LETableViewCellAffinitySelectorV2 getCellForTableView:self.tableView];
	self.miningCell.nameLabel.text = @"Mining";
	self.miningCell.pointsDelegate = self;
	self.miningCell.viewController = self;
	[self.miningCell setRating:_intv([self.speciesTemplate objectForKey:@"mining_affinity"])];
	
	self.scienceCell = [LETableViewCellAffinitySelectorV2 getCellForTableView:self.tableView];
	self.scienceCell.nameLabel.text = @"Science";
	self.scienceCell.pointsDelegate = self;
	self.scienceCell.viewController = self;
	[self.scienceCell setRating:_intv([self.speciesTemplate objectForKey:@"science_affinity"])];
	
	self.environmentalCell = [LETableViewCellAffinitySelectorV2 getCellForTableView:self.tableView];
	self.environmentalCell.nameLabel.text = @"Environmental";
	self.environmentalCell.pointsDelegate = self;
	self.environmentalCell.viewController = self;
	[self.environmentalCell setRating:_intv([self.speciesTemplate objectForKey:@"environmental_affinity"])];
	
	self.politicalCell = [LETableViewCellAffinitySelectorV2 getCellForTableView:self.tableView];
	self.politicalCell.nameLabel.text = @"Political";
	self.politicalCell.pointsDelegate = self;
	self.politicalCell.viewController = self;
	[self.politicalCell setRating:_intv([self.speciesTemplate objectForKey:@"political_affinity"])];
	
	self.tradeCell = [LETableViewCellAffinitySelectorV2 getCellForTableView:self.tableView];
	self.tradeCell.nameLabel.text = @"Trade";
	self.tradeCell.pointsDelegate = self;
	self.tradeCell.viewController = self;
	[self.tradeCell setRating:_intv([self.speciesTemplate objectForKey:@"trade_affinity"])];
	
	self.growthCell = [LETableViewCellAffinitySelectorV2 getCellForTableView:self.tableView];
	self.growthCell.nameLabel.text = @"Growth";
	self.growthCell.pointsDelegate = self;
	self.growthCell.viewController = self;
	[self.growthCell setRating:_intv([self.speciesTemplate objectForKey:@"growth_affinity"])];
	
	[self calculatePoints];
	self.navigationItem.title = [NSString stringWithFormat:@"%li / 45 points", (long)self->points];
	
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
			return 2;
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
		case SECTION_AFFINITIES:
			return [LETableViewCellAffinitySelectorV2 getHeightForTableView:tableView];
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
	UITableViewCell *cell = nil;
	
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
	self.empireId = nil;
	self.username = nil;
	self.password = nil;
	self.speciesTemplate = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance methods

- (IBAction)createSpecies {
	if (_intv(self.maxOrbitCell.rating) < _intv(self.minOrbitCell.rating)) {
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Invalid Orbits" message: @"Max Orbit must be greater than or equal to min orbit." preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
		
	} else if (self->points > 45) {
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Too many points" message:[NSString stringWithFormat:@"You have spent %li points, but you can only spend 45 points.", (long)self->points] preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
		
	} else if (self->points < 45) {
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Too few points" message:[NSString stringWithFormat:@"You have spent %li points, but you must spend 45 points.", (long)self->points] preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
		
	} else {
		self.pendingRequest = YES;
		[[[LEEmpireUpdateSpecies alloc] initWithCallback:@selector(speciesCreated:) target:self
										  empireId:self.empireId
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
	self.navigationItem.title = [NSString stringWithFormat:@"%li / 45 points", (long)self->points];
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

- (id)speciesCreated:(LEEmpireUpdateSpecies *) request {
	self.pendingRequest = NO;
	if ([request wasError]) {
		switch ([request errorCode]) {
			case 1009:
				; //DO NOT REMOVE
				[request markErrorHandled];
				
				UIAlertController *nameAlertView = [UIAlertController alertControllerWithTitle:@"Could not create species" message: @"Your selected orbits must be continuous. You cannot have a break within the list of habital orbits." preferredStyle:UIAlertControllerStyleAlert];
				UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
									 { [nameAlertView dismissViewControllerAnimated:YES completion:nil]; }];
				[nameAlertView addAction: ok];
				[self presentViewController:nameAlertView animated:YES completion:nil];
				break;
		}
	} else {
		[[[LEEmpireFound alloc] initWithCallback:@selector(empireFounded:) target:self empireId:self.empireId] autorelease];
	}
	
	return nil;
}


- (id)empireFounded:(LEEmpireFound *) request {
	self.pendingRequest = NO;
	if ([request wasError]) {
		//WHAT TO DO?
	} else {
		[self.navigationController popToRootViewControllerAnimated:YES];
		Session *session = [Session sharedInstance];
		session.lacunanMessageId = request.welcomeMessageId;
		[session loggedInEmpireData:request.empireData sessionId:request.sessionId password:self.password];
	}
	
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (NewSpeciesController *) create {
	return [[[NewSpeciesController alloc] init] autorelease];
}


@end

