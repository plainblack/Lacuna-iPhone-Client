//
//  FetchSpiesController.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "FetchSpiesController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "Ship.h"
#import "Spy.h"
#import "LEBuildingPrepareFetchSpies.h"
#import "LEBuildingFetchSpies.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellShip.h"
#import "LETableViewCellSpyInfo.h"


typedef enum {
	SECTION_SEND_TO,
	SECTION_SELECTED_SHIP,
	SECTION_SELECTED_SPIES,
} SECTIONS;


@implementation FetchSpiesController


@synthesize mapItem;
@synthesize fetchToBodyId;
@synthesize spyShips;
@synthesize shipTravelTimes;
@synthesize selectedShip;
@synthesize spies;
@synthesize selectedSpies;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Fetch Spies";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Fetch" style:UIBarButtonItemStyleDone target:self action:@selector(fetch)] autorelease];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"To"], [LEViewSectionTab tableView:self.tableView withText:@"Ship"], [LEViewSectionTab tableView:self.tableView withText:@"Spies"]);
	
	if (!self.selectedSpies) {
		self.selectedSpies = [NSMutableArray arrayWithCapacity:5];
	}
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	if (self.fetchToBodyId && !self.spyShips) {
		[[[LEBuildingPrepareFetchSpies alloc] initWithCallback:@selector(prepareDataLoaded:) target:self onBodyId:self.mapItem.id toBodyId:self.fetchToBodyId] autorelease];
	}
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
		case SECTION_SEND_TO:
			return 1;
			break;
		case SECTION_SELECTED_SHIP:
			return 1;
		case SECTION_SELECTED_SPIES:
			if ([self.spies count] > 0) {
				return MAX([self.selectedSpies count] + 1, 1);
			} else {
				return MAX([self.selectedSpies count], 1);
			}
		default:
			return 0;
			break;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_SEND_TO:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case SECTION_SELECTED_SHIP:
			if ([self.spyShips count] > 0) {
				if (self.selectedShip) {
					return [LETableViewCellShip getHeightForTableView:tableView];
				} else {
					return [LETableViewCellButton getHeightForTableView:tableView];
				}
			} else {
				return [LETableViewCellLabeledText getHeightForTableView:tableView];
			}
		case SECTION_SELECTED_SPIES:
			if ([self.spies count] > 0 || [self.selectedSpies count] > 0) {
				if (indexPath.row < [self.selectedSpies count]) {
					return [LETableViewCellSpyInfo getHeightForTableView:tableView];
				} else {
					return [LETableViewCellButton getHeightForTableView:tableView];
				}
			} else {
				return [LETableViewCellLabeledText getHeightForTableView:tableView];
			}
		default:
			return 0;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
	switch (indexPath.section) {
		case SECTION_SEND_TO:
			; //DO NOT REMOVE
			LETableViewCellButton *selectColonyButton = [LETableViewCellButton getCellForTableView:tableView];
			if (self.fetchToBodyId) {
				Session *session = [Session sharedInstance];
				[session.empire.planets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
					if ([[obj objectForKey:@"id"] isEqualToString:self.fetchToBodyId]) {
						selectColonyButton.textLabel.text = [obj objectForKey:@"name"];
						*stop = YES;
					}
				}];
			} else {
				selectColonyButton.textLabel.text = @"Select Colony";
			}
			cell = selectColonyButton;
			break;
		case SECTION_SELECTED_SHIP:
			if (self.spyShips) {
				if ([self.spyShips count] > 0) {
					; //DO NOT REMOVE
					if (self.selectedShip) {
						LETableViewCellShip *selectShipButton = [LETableViewCellShip getCellForTableView:tableView isSelectable:YES];
						[selectShipButton setShip:self.selectedShip];
						cell = selectShipButton;
					} else {
						LETableViewCellButton *selectShipButton = [LETableViewCellButton getCellForTableView:tableView];
						selectShipButton.textLabel.text = @"Select Ship";
						cell = selectShipButton;
					}
				} else {
					LETableViewCellLabeledText *noShipsCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					noShipsCell.label.text = @"Available Ships";
					noShipsCell.content.text = @"None";
					cell = noShipsCell;
				}
			} else {
				LETableViewCellLabeledText *loadingShipsCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				loadingShipsCell.label.text = @"Available Ships";
				loadingShipsCell.content.text = @"Loading";
				cell = loadingShipsCell;
			}
			break;
		case SECTION_SELECTED_SPIES:
			if (self.spies) {
				if ([self.spies count] > 0 || [self.selectedSpies count] > 0) {
					if (indexPath.row < [self.selectedSpies count]) {
						Spy *spy = [self.selectedSpies objectAtIndex:indexPath.row];
						LETableViewCellSpyInfo *spyCell = [LETableViewCellSpyInfo getCellForTableView:tableView];
						[spyCell setData:spy];
						cell = spyCell;
					} else {
						LETableViewCellButton *addSpyButton = [LETableViewCellButton getCellForTableView:tableView];
						addSpyButton.textLabel.text = @"Add Spy";
						cell = addSpyButton;
					}
				} else {
					LETableViewCellLabeledText *noSpiesCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					noSpiesCell.label.text = @"Available Spies";
					noSpiesCell.content.text = @"None";
					cell = noSpiesCell;
				}
			} else {
				LETableViewCellLabeledText *loadingSpiesCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				loadingSpiesCell.label.text = @"Available Spies";
				loadingSpiesCell.content.text = @"Loading";
				cell = loadingSpiesCell;
			}
			break;
		default:
			return 0;
			break;
	}
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_SEND_TO:
			; //DO NOT REMOVE
			Session *session = [Session	 sharedInstance];
			self->pickColonyController = [[PickColonyController create] retain];
			self->pickColonyController.delegate = self;
			self->pickColonyController.colonies = session.empire.planets;
			[self presentViewController:self->pickColonyController animated:YES completion:nil];
			break;
		case SECTION_SELECTED_SHIP:
			; //DO NOT REMOVE
			SelectShipFromListController *selectShipFromListController = [SelectShipFromListController create];
			selectShipFromListController.ships = self.spyShips;
			selectShipFromListController.shipTravelTimes = self.shipTravelTimes;
			selectShipFromListController.delegate = self;
			[self.navigationController pushViewController:selectShipFromListController animated:YES];
			break;
		case SECTION_SELECTED_SPIES:
			if ([self.spies count] > 0 && indexPath.row >= [self.selectedSpies count]) {
				SelectSpyFromListController *selectSpyFromListController = [SelectSpyFromListController create];
				selectSpyFromListController.spies = self.spies;
				selectSpyFromListController.delegate = self;
				[self.navigationController pushViewController:selectSpyFromListController animated:YES];
			}
			break;
	}
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_SELECTED_SPIES:
			return [self.spies count] > 0 && indexPath.row < [self.selectedSpies count];
			break;
		default:
			return NO;
			break;
	}
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ( ([self.spies count] > 0 && indexPath.row < [self.selectedSpies count]) && (editingStyle == UITableViewCellEditingStyleDelete) ) {
		Spy *spy = [self.selectedSpies objectAtIndex:indexPath.row];
		[self.selectedSpies removeObject:spy];
		[self.spies addObject:spy];
		[self.tableView reloadData];
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
	self.mapItem = nil;
	self.fetchToBodyId = nil;
	self.spyShips = nil;
	self.selectedShip = nil;
	self.spies = nil;
	self.selectedSpies = nil;
	[self->pickColonyController release];
	self->pickColonyController = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark PickColonyDelegate Methods

- (void)colonySelected:(NSString *)colonyId {
	self.fetchToBodyId = colonyId;
	[self dismissViewControllerAnimated:YES completion:nil];
	[self->pickColonyController release];
	self->pickColonyController = nil;
	[[[LEBuildingPrepareFetchSpies alloc] initWithCallback:@selector(prepareDataLoaded:) target:self onBodyId:self.mapItem.id toBodyId:self.fetchToBodyId] autorelease];
	self.spyShips = nil;
	self.selectedShip = nil;
	self.spies = nil;
	[self.selectedSpies removeAllObjects];
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark SelectShipFromListControllerDelegate Methods

- (void)shipSelected:(Ship *)ship {
	self.selectedShip = ship;
	[self.tableView reloadData];
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark SelectSpyFromListControllerDelegate Methods

- (void)spySelected:(Spy *)spy {
	[self.spies removeObject:spy];
	[self.selectedSpies addObject:spy];
	[self.tableView reloadData];
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Action Methods

- (IBAction)fetch {
	if (self.selectedShip) {
		if ([self.selectedSpies count] > 0) {
			NSMutableArray *selectedSpyIds = [NSMutableArray arrayWithCapacity:[self.selectedSpies count]];
			for (Spy *spy in self.selectedSpies) {
				[selectedSpyIds addObject:spy.id];
			}
			[[[LEBuildingFetchSpies alloc] initWithCallback:@selector(spiesLeft:) target:self onBodyId:self.mapItem.id toBodyId:self.fetchToBodyId shipId:self.selectedShip.id spyIds:selectedSpyIds] autorelease];
		} else {
			UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Incomplete" message: @"You must select at least one spy to send." preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
								 { [av dismissViewControllerAnimated:YES completion:nil]; }];
			[av addAction: ok];
			[self presentViewController:av animated:YES completion:nil];
		}
		
	} else {
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Incomplete" message: @"You must select a ship to be used." preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
	}
	
}


#pragma mark -
#pragma mark Callback Methods

- (void)prepareDataLoaded:(LEBuildingPrepareFetchSpies *)request {
	NSMutableArray *tmpShips = [NSMutableArray arrayWithCapacity:[request.ships count]];
	NSMutableDictionary *tmpTravelTimes = [NSMutableDictionary dictionaryWithCapacity:[request.ships count]];
	for (NSMutableDictionary *shipData in request.ships) {
		Ship *ship = [[Ship alloc] init];
		[ship parseData:shipData];
		[tmpShips addObject:ship];
		NSDecimalNumber *estimatedTravelTime = [shipData objectForKey:@"estimated_travel_time"];
		if (isNull(estimatedTravelTime)) {
			estimatedTravelTime = [NSDecimalNumber zero];
		}
		[tmpTravelTimes setObject:estimatedTravelTime forKey:ship.id];
		[ship release];
	}
	self.spyShips = tmpShips;
	self.shipTravelTimes = tmpTravelTimes;
	
	NSMutableArray *tmpSpies = [NSMutableArray arrayWithCapacity:[request.spies count]];
	for (NSMutableDictionary *spyData in request.spies) {
		Spy *spy = [[Spy alloc] init];
		[spy parseData:spyData];
		[tmpSpies addObject:spy];
		[spy release];
	}
	self.spies = tmpSpies;
	
	[self.tableView reloadData];
}


- (void)spiesLeft:(LEBuildingFetchSpies *)request {
	if (![request wasError]) {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

#pragma mark -
#pragma mark Class Methods

+ (FetchSpiesController *)create {
	return [[[FetchSpiesController alloc] init] autorelease];
}


@end

