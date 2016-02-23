//
//  ViewEmpireBoostsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 5/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewEmpireBoostsController.h"
#import "LEMacros.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LEEmpireViewBoosts.h"
#import "LEEmpireBoostEnergy.h"
#import "LEEmpireBoostFood.h"
#import "LEEmpireBoostHappiness.h"
#import "LEEmpireBoostOre.h"
#import "LEEmpireBoostWater.h"
#import "LEEmpireBoostStorage.h"
#import "LEEmpireBoostBuilding.h"
#import "LEEmpireBoostSpyTraining.h"
#import "Util.h"


typedef enum {
	EMPIRE_BOOST_SECTION_ENERGY,
	EMPIRE_BOOST_SECTION_FOOD,
	EMPIRE_BOOST_SECTION_HAPPINESS,
	EMPIRE_BOOST_SECTION_ORE,
	EMPIRE_BOOST_SECTION_WATER,
	EMPIRE_BOOST_SECTION_STORAGE,
    EMPIRE_BOOST_SECTION_BUILDING,
	EMPIRE_BOOST_SECTION_SPY_TRAINING,
} EMPIRE_BOOST_SECTION;


typedef enum {
	EMPIRE_BOOST_ROW_EXPIRES,
	EMPIRE_BOOST_ROW_BUTTON
} EMPIRE_BOOST_ROW;


@implementation ViewEmpireBoostsController


@synthesize empireBoosts;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.title = @"Loading";
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Energy" withIcon:ENERGY_ICON],
								 [LEViewSectionTab tableView:self.tableView withText:@"Food" withIcon:FOOD_ICON],
								 [LEViewSectionTab tableView:self.tableView withText:@"Happiness" withIcon:HAPPINESS_ICON],
								 [LEViewSectionTab tableView:self.tableView withText:@"Ore" withIcon:ORE_ICON],
								 [LEViewSectionTab tableView:self.tableView withText:@"Water" withIcon:WATER_ICON],
								 [LEViewSectionTab tableView:self.tableView withText:@"Storage" withIcon:STORAGE_ICON],
								 [LEViewSectionTab tableView:self.tableView withText:@"Building" withIcon:BUILD_ICON],
								 [LEViewSectionTab tableView:self.tableView withText:@"Spy Training" withIcon:SPY_ICON]);
	
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.empireBoosts = nil;
	[[[LEEmpireViewBoosts alloc] initWithCallback:@selector(boostsLoaded:) target:self] autorelease];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.empireBoosts) {
		return 8;
	} else {
		return 0;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.empireBoosts) {
		return 2;
	} else {
		return 0;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case EMPIRE_BOOST_SECTION_ENERGY:
		case EMPIRE_BOOST_SECTION_FOOD:
		case EMPIRE_BOOST_SECTION_HAPPINESS:
		case EMPIRE_BOOST_SECTION_ORE:
		case EMPIRE_BOOST_SECTION_WATER:
		case EMPIRE_BOOST_SECTION_STORAGE:
		case EMPIRE_BOOST_SECTION_SPY_TRAINING:
        case EMPIRE_BOOST_SECTION_BUILDING:
			switch (indexPath.row) {
				case EMPIRE_BOOST_ROW_EXPIRES:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case EMPIRE_BOOST_ROW_BUTTON:
					return [LETableViewCellButton getHeightForTableView:tableView];
					break;
				default:
					return 0.0;
					break;
			}
			break;
		default:
			return 0.0;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
	
	switch (indexPath.section) {
		case EMPIRE_BOOST_SECTION_ENERGY:
			; //DO NOT REMOVE
			NSDate *energyBoostEndDate = [self.empireBoosts objectForKey:@"energy"];
			switch (indexPath.row) {
				case EMPIRE_BOOST_ROW_EXPIRES:
					cell = [self setupExpiresCellForTableView:tableView secondsRemaining:[energyBoostEndDate timeIntervalSinceNow]];
					break;
				case EMPIRE_BOOST_ROW_BUTTON:
					cell = [self setupButtonCellForTableView:tableView secondsRemaining:[energyBoostEndDate timeIntervalSinceNow] name:@"Energy"];
					break;
				default:
					cell = nil;
					break;
			}
			break;
		case EMPIRE_BOOST_SECTION_FOOD:
			; //DO NOT REMOVE
			NSDate *foodBoostEndDate = [self.empireBoosts objectForKey:@"food"];
			switch (indexPath.row) {
				case EMPIRE_BOOST_ROW_EXPIRES:
					cell = [self setupExpiresCellForTableView:tableView secondsRemaining:[foodBoostEndDate timeIntervalSinceNow]];
					break;
				case EMPIRE_BOOST_ROW_BUTTON:
					cell = [self setupButtonCellForTableView:tableView secondsRemaining:[foodBoostEndDate timeIntervalSinceNow] name:@"Food"];
					break;
				default:
					cell = nil;
					break;
			}
			break;
		case EMPIRE_BOOST_SECTION_HAPPINESS:
			; //DO NOT REMOVE
			NSDate *happinessBoostEndDate = [self.empireBoosts objectForKey:@"happiness"];
			switch (indexPath.row) {
				case EMPIRE_BOOST_ROW_EXPIRES:
					cell = [self setupExpiresCellForTableView:tableView secondsRemaining:[happinessBoostEndDate timeIntervalSinceNow]];
					break;
				case EMPIRE_BOOST_ROW_BUTTON:
					cell = [self setupButtonCellForTableView:tableView secondsRemaining:[happinessBoostEndDate timeIntervalSinceNow] name:@"Happiness"];
					break;
				default:
					cell = nil;
					break;
			}
			break;
		case EMPIRE_BOOST_SECTION_ORE:
			; //DO NOT REMOVE
			NSDate *oreBoostEndDate = [self.empireBoosts objectForKey:@"ore"];
			switch (indexPath.row) {
				case EMPIRE_BOOST_ROW_EXPIRES:
					cell = [self setupExpiresCellForTableView:tableView secondsRemaining:[oreBoostEndDate timeIntervalSinceNow]];
					break;
				case EMPIRE_BOOST_ROW_BUTTON:
					cell = [self setupButtonCellForTableView:tableView secondsRemaining:[oreBoostEndDate timeIntervalSinceNow] name:@"Ore"];
					break;
				default:
					cell = nil;
					break;
			}
			break;
		case EMPIRE_BOOST_SECTION_WATER:
			; //DO NOT REMOVE
			NSDate *waterBoostEndDate = [self.empireBoosts objectForKey:@"water"];
			switch (indexPath.row) {
				case EMPIRE_BOOST_ROW_EXPIRES:
					cell = [self setupExpiresCellForTableView:tableView secondsRemaining:[waterBoostEndDate timeIntervalSinceNow]];
					break;
				case EMPIRE_BOOST_ROW_BUTTON:
					cell = [self setupButtonCellForTableView:tableView secondsRemaining:[waterBoostEndDate timeIntervalSinceNow] name:@"Water"];
					break;
				default:
					cell = nil;
					break;
			}
			break;
		case EMPIRE_BOOST_SECTION_STORAGE:
			; //DO NOT REMOVE
			NSDate *storageBoostEndDate = [self.empireBoosts objectForKey:@"storage"];
			switch (indexPath.row) {
				case EMPIRE_BOOST_ROW_EXPIRES:
					cell = [self setupExpiresCellForTableView:tableView secondsRemaining:[storageBoostEndDate timeIntervalSinceNow]];
					break;
				case EMPIRE_BOOST_ROW_BUTTON:
					cell = [self setupButtonCellForTableView:tableView secondsRemaining:[storageBoostEndDate timeIntervalSinceNow] name:@"Storage"];
					break;
				default:
					cell = nil;
					break;
            }
			break;
		case EMPIRE_BOOST_SECTION_BUILDING:
			; //DO NOT REMOVE
			NSDate *buildingBoostEndDate = [self.empireBoosts objectForKey:@"building"];
			switch (indexPath.row) {
				case EMPIRE_BOOST_ROW_EXPIRES:
					cell = [self setupExpiresCellForTableView:tableView secondsRemaining:[buildingBoostEndDate timeIntervalSinceNow]];
					break;
				case EMPIRE_BOOST_ROW_BUTTON:
					cell = [self setupButtonCellForTableView:tableView secondsRemaining:[buildingBoostEndDate timeIntervalSinceNow] name:@"Building"];
					break;
				default:
					cell = nil;
					break;
			}
			break;
		case EMPIRE_BOOST_SECTION_SPY_TRAINING:
			; //DO NOT REMOVE
			NSDate *spyTrainingBoostEndDate = [self.empireBoosts objectForKey:@"spy_training"];
			switch (indexPath.row) {
				case EMPIRE_BOOST_ROW_EXPIRES:
					cell = [self setupExpiresCellForTableView:tableView secondsRemaining:[spyTrainingBoostEndDate timeIntervalSinceNow]];
					break;
				case EMPIRE_BOOST_ROW_BUTTON:
					cell = [self setupButtonCellForTableView:tableView secondsRemaining:[spyTrainingBoostEndDate timeIntervalSinceNow] name:@"Spy Training"];
					break;
				default:
					cell = nil;
					break;
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
	NSString *msg = nil;
	switch (indexPath.section) {
		case EMPIRE_BOOST_SECTION_ENERGY:
			msg = [NSString stringWithFormat:@"Are you sure you want to spend 5 essentia to boost your Energy Production by 25%%?"];
			break;
		case EMPIRE_BOOST_SECTION_FOOD:
			msg = [NSString stringWithFormat:@"Are you sure you want to spend 5 essentia to boost your Food Production by 25%%?"];
			break;
		case EMPIRE_BOOST_SECTION_HAPPINESS:
			msg = [NSString stringWithFormat:@"Are you sure you want to spend 5 essentia to boost your Happiness Production by 25%%?"];
			break;
		case EMPIRE_BOOST_SECTION_ORE:
			msg = [NSString stringWithFormat:@"Are you sure you want to spend 5 essentia to boost your Ore Production by 25%%?"];
			break;
		case EMPIRE_BOOST_SECTION_WATER:
			msg = [NSString stringWithFormat:@"Are you sure you want to spend 5 essentia to boost your Water Production by 25%%?"];
			break;
		case EMPIRE_BOOST_SECTION_STORAGE:
			msg = [NSString stringWithFormat:@"Are you sure you want to spend 5 essentia to boost your Storage Capacity by 25%%?"];
			break;
        case EMPIRE_BOOST_SECTION_BUILDING:
			msg = [NSString stringWithFormat:@"Are you sure you want to spend 5 essentia to boost your Building Speed by 25%%?"];
			break;
		case EMPIRE_BOOST_SECTION_SPY_TRAINING:
			msg = [NSString stringWithFormat:@"Are you sure you want to spend 5 essentia to boost your Spy Training Speed by 25%%?"];
			break;
	}
	if (msg) {
		self->selectedSection = indexPath.section;
		
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:msg message:@"" preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
			switch (self->selectedSection) {
				case EMPIRE_BOOST_SECTION_ENERGY:
					[[[LEEmpireBoostEnergy alloc] initWithCallback:@selector(boostedEnergy:) target:self] autorelease];
					break;
				case EMPIRE_BOOST_SECTION_FOOD:
					[[[LEEmpireBoostFood alloc] initWithCallback:@selector(boostedFood:) target:self] autorelease];
					break;
				case EMPIRE_BOOST_SECTION_HAPPINESS:
					[[[LEEmpireBoostHappiness alloc] initWithCallback:@selector(boostedHappiness:) target:self] autorelease];
					break;
				case EMPIRE_BOOST_SECTION_ORE:
					[[[LEEmpireBoostOre alloc] initWithCallback:@selector(boostedOre:) target:self] autorelease];
					break;
				case EMPIRE_BOOST_SECTION_WATER:
					[[[LEEmpireBoostWater alloc] initWithCallback:@selector(boostedWater:) target:self] autorelease];
					break;
				case EMPIRE_BOOST_SECTION_STORAGE:
					[[[LEEmpireBoostStorage alloc] initWithCallback:@selector(boostedStorage:) target:self] autorelease];
					break;
				case EMPIRE_BOOST_SECTION_BUILDING:
					[[[LEEmpireBoostBuilding alloc] initWithCallback:@selector(boostedBuilding:) target:self] autorelease];
					break;
				case EMPIRE_BOOST_SECTION_SPY_TRAINING:
					[[[LEEmpireBoostSpyTraining alloc] initWithCallback:@selector(boostedSpyTraining:) target:self] autorelease];
					break;
			}
		}];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
		}];
		[alert addAction:cancelAction];
		[alert addAction:okAction];
		[self presentViewController:alert animated:YES completion:nil];
		[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
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
	self.empireBoosts = nil;
	[self->timer invalidate];
	[self->timer release];
	self->timer = nil;	
	[super viewDidUnload];
}


- (void)dealloc {
	self.empireBoosts = nil;
	[self->timer invalidate];
	[self->timer release];
	self->timer = nil;	
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods


- (UITableViewCell *)setupExpiresCellForTableView:(UITableView *)tableView secondsRemaining:(NSInteger)secondsRemaining {
	; //DO NOT REMOVE
	LETableViewCellLabeledText *expiresCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
	expiresCell.label.text = @"Expires in";
	if (secondsRemaining > 0) {
		expiresCell.content.text = [Util prettyDuration:secondsRemaining];
	} else {
		expiresCell.content.text = @"Not Boosting";
	}
	
	return expiresCell;
}


- (UITableViewCell *)setupButtonCellForTableView:(UITableView *)tableView secondsRemaining:(NSInteger)secondsRemaining name:(NSString *)name {
	LETableViewCellButton *buttonCell = [LETableViewCellButton getCellForTableView:tableView];
	if (secondsRemaining > 0) {
		buttonCell.textLabel.text = [NSString stringWithFormat:@"Extend %@ Boost", name];
	} else {
		buttonCell.textLabel.text = [NSString stringWithFormat:@"Start %@ Boost", name];
	}
	return buttonCell;
}


#pragma mark -
#pragma mark Callbacks

- (id)boostsLoaded:(LEEmpireViewBoosts *)request {
	self.navigationItem.title = @"Empire Boosts";
	self.empireBoosts = [NSMutableDictionary dictionaryWithDictionary:request.boosts];
	self->timer = [[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES] retain];

	[self.tableView reloadData];
	return nil;
}


- (void)handleTimer:(NSTimer *)theTimer {
	[self.tableView reloadData];
}


- (id)boostedEnergy:(LEEmpireBoostEnergy *)request {
	if (![request wasError]) {
		[self.empireBoosts setObject:request.boostEndDate forKey:@"energy"];
		[self.tableView reloadData];
	}
	return nil;
}


- (id)boostedFood:(LEEmpireBoostFood *)request {
	if (![request wasError]) {
		[self.empireBoosts setObject:request.boostEndDate forKey:@"food"];
		[self.tableView reloadData];
	}
	return nil;
}


- (id)boostedHappiness:(LEEmpireBoostHappiness *)request {
	if (![request wasError]) {
		[self.empireBoosts setObject:request.boostEndDate forKey:@"happiness"];
		[self.tableView reloadData];
	}
	return nil;
}


- (id)boostedOre:(LEEmpireBoostOre *)request {
	if (![request wasError]) {
		[self.empireBoosts setObject:request.boostEndDate forKey:@"ore"];
		[self.tableView reloadData];
	}
	return nil;
}


- (id)boostedWater:(LEEmpireBoostWater *)request {
	if (![request wasError]) {
		[self.empireBoosts setObject:request.boostEndDate forKey:@"water"];
		[self.tableView reloadData];
	}
	return nil;
}


- (id)boostedStorage:(LEEmpireBoostStorage *)request {
	if (![request wasError]) {
		[self.empireBoosts setObject:request.boostEndDate forKey:@"storage"];
		[self.tableView reloadData];
	}
	return nil;
}

- (id)boostedBuilding:(LEEmpireBoostBuilding *)request {
	if (![request wasError]) {
		[self.empireBoosts setObject:request.boostEndDate forKey:@"building"];
		[self.tableView reloadData];
	}
	return nil;
}

- (id)boostedSpyTraining:(LEEmpireBoostSpyTraining *)request {
	if (![request wasError]) {
		[self.empireBoosts setObject:request.boostEndDate forKey:@"spy_training"];
		[self.tableView reloadData];
	}
	return nil;
 }


#pragma mark -
#pragma mark Class Methods

+ (ViewEmpireBoostsController *) create {
	return [[[ViewEmpireBoostsController alloc] init] autorelease];
}


@end

