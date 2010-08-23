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
#import "Util.h"


typedef enum {
	EMPIRE_BOOST_ROW_ENERGY,
	EMPIRE_BOOST_ROW_FOOD,
	EMPIRE_BOOST_ROW_HAPPINESS,
	EMPIRE_BOOST_ROW_ORE,
	EMPIRE_BOOST_ROW_WATER,
	EMPIRE_BOOST_ROW_STORAGE
} EMPIRE_ROW;


@implementation ViewEmpireBoostsController


@synthesize empireBoosts;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
    //self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
	self.navigationItem.title = @"Loading";
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView createWithText:@"Empire Boosts"]);
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
		return 1;
	} else {
		return 0;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.empireBoosts) {
		return 6;
	} else {
		return 0;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
	
	switch (indexPath.row) {
		case EMPIRE_BOOST_ROW_ENERGY:
			cell = [self setupCellForTableView:tableView boostEndDate:[self.empireBoosts objectForKey:@"energy"] name:@"Energy"];
			break;
		case EMPIRE_BOOST_ROW_FOOD:
			cell = [self setupCellForTableView:tableView boostEndDate:[self.empireBoosts objectForKey:@"food"] name:@"Food"];
			break;
		case EMPIRE_BOOST_ROW_HAPPINESS:
			cell = [self setupCellForTableView:tableView boostEndDate:[self.empireBoosts objectForKey:@"happiness"] name:@"Happiness"];
			break;
		case EMPIRE_BOOST_ROW_ORE:
			cell = [self setupCellForTableView:tableView boostEndDate:[self.empireBoosts objectForKey:@"ore"] name:@"Ore"];
			break;
		case EMPIRE_BOOST_ROW_WATER:
			cell = [self setupCellForTableView:tableView boostEndDate:[self.empireBoosts objectForKey:@"water"] name:@"Water"];
			break;
		case EMPIRE_BOOST_ROW_STORAGE:
			cell = [self setupCellForTableView:tableView boostEndDate:[self.empireBoosts objectForKey:@"storage"] name:@"Storage"];
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
	switch (indexPath.row) {
		case EMPIRE_BOOST_ROW_ENERGY:
			msg = [NSString stringWithFormat:@"Are you sure you want to spend 2 essentia to boost your Energy Production by 25%%?"];
			break;
		case EMPIRE_BOOST_ROW_FOOD:
			msg = [NSString stringWithFormat:@"Are you sure you want to spend 2 essentia to boost your Food Production by 25%%?"];
			break;
		case EMPIRE_BOOST_ROW_HAPPINESS:
			msg = [NSString stringWithFormat:@"Are you sure you want to spend 2 essentia to boost your Happiness Production by 25%%?"];
			break;
		case EMPIRE_BOOST_ROW_ORE:
			msg = [NSString stringWithFormat:@"Are you sure you want to spend 2 essentia to boost your Ore Production by 25%%?"];
			break;
		case EMPIRE_BOOST_ROW_WATER:
			msg = [NSString stringWithFormat:@"Are you sure you want to spend 2 essentia to boost your Water Production by 25%%?"];
			break;
		case EMPIRE_BOOST_ROW_STORAGE:
			msg = [NSString stringWithFormat:@"Are you sure you want to spend 2 essentia to boost your Storage Capacity by 25%%?"];
			break;
	}
	if (msg) {
		self->selectedRow = indexPath.row;
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:msg delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
		actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
		[actionSheet showFromTabBar:self.tabBarController.tabBar];
		[actionSheet release];
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
	[super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark --
#pragma mark Instance Methods

- (UITableViewCell *)setupCellForTableView:(UITableView *)tableView boostEndDate:(NSDate *)boostEndDate name:(NSString *)name {
	if ([self isBoosting:boostEndDate]) {
		LETableViewCellLabeledText *energyPendingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		energyPendingCell.label.text = name;
		energyPendingCell.content.text = [Util formatDate:boostEndDate];
		return energyPendingCell;
	} else {
		LETableViewCellButton *energyButtonCell = [LETableViewCellButton getCellForTableView:tableView];
		energyButtonCell.textLabel.text = [NSString stringWithFormat:@"Purchase %@ Boost", name];
		return energyButtonCell;
	}
}


- (BOOL)isBoosting:(NSDate *)boostEndDate {
	NSDate *now = [NSDate date];
	return [boostEndDate compare:now] == NSOrderedDescending;
}


#pragma mark -
#pragma mark UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.destructiveButtonIndex == buttonIndex ) {
		switch (self->selectedRow) {
			case EMPIRE_BOOST_ROW_ENERGY:
				if (![self isBoosting:[self.empireBoosts objectForKey:@"energy"]]) {
					[[[LEEmpireBoostEnergy alloc] initWithCallback:@selector(boostedEnergy:) target:self] autorelease];
				}
				break;
			case EMPIRE_BOOST_ROW_FOOD:
				if (![self isBoosting:[self.empireBoosts objectForKey:@"food"]]) {
					[[[LEEmpireBoostFood alloc] initWithCallback:@selector(boostedFood:) target:self] autorelease];
				}
				break;
			case EMPIRE_BOOST_ROW_HAPPINESS:
				if (![self isBoosting:[self.empireBoosts objectForKey:@"happiness"]]) {
					[[[LEEmpireBoostHappiness alloc] initWithCallback:@selector(boostedHappiness:) target:self] autorelease];
				}
				break;
			case EMPIRE_BOOST_ROW_ORE:
				if (![self isBoosting:[self.empireBoosts objectForKey:@"ore"]]) {
					[[[LEEmpireBoostOre alloc] initWithCallback:@selector(boostedOre:) target:self] autorelease];
				}
				break;
			case EMPIRE_BOOST_ROW_WATER:
				if (![self isBoosting:[self.empireBoosts objectForKey:@"water"]]) {
					[[[LEEmpireBoostWater alloc] initWithCallback:@selector(boostedWater:) target:self] autorelease];
				}
				break;
			case EMPIRE_BOOST_ROW_STORAGE:
				if (![self isBoosting:[self.empireBoosts objectForKey:@"storage"]]) {
					[[[LEEmpireBoostStorage alloc] initWithCallback:@selector(boostedStorage:) target:self] autorelease];
				}
				break;
		}
	}
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


#pragma mark --
#pragma mark Callbacks

- (id)boostsLoaded:(LEEmpireViewBoosts *)request {
	self.navigationItem.title = @"Empire Boosts";
	self.empireBoosts = [NSMutableDictionary dictionaryWithDictionary:request.boosts];
	[self.tableView reloadData];
	return nil;
}


- (id)boostedEnergy:(LEEmpireBoostEnergy *)request {
	[self.empireBoosts setObject:request.boostEndDate forKey:@"energy"];
	[self.tableView reloadData];
	return nil;
}


- (id)boostedFood:(LEEmpireBoostFood *)request {
	[self.empireBoosts setObject:request.boostEndDate forKey:@"food"];
	[self.tableView reloadData];
	return nil;
}


- (id)boostedHappiness:(LEEmpireBoostHappiness *)request {
	[self.empireBoosts setObject:request.boostEndDate forKey:@"happiness"];
	[self.tableView reloadData];
	return nil;
}


- (id)boostedOre:(LEEmpireBoostOre *)request {
	[self.empireBoosts setObject:request.boostEndDate forKey:@"ore"];
	[self.tableView reloadData];
	return nil;
}


- (id)boostedWater:(LEEmpireBoostWater *)request {
	[self.empireBoosts setObject:request.boostEndDate forKey:@"water"];
	[self.tableView reloadData];
	return nil;
}


- (id)boostedStorage:(LEEmpireBoostStorage *)request {
	[self.empireBoosts setObject:request.boostEndDate forKey:@"storage"];
	[self.tableView reloadData];
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (ViewEmpireBoostsController *) create {
	return [[[ViewEmpireBoostsController alloc] init] autorelease];
}


@end

