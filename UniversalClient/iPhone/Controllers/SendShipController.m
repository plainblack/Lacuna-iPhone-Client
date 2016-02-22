//
//  SendShipController.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "SendShipController.h"
#import "Util.h"
#import "LEMacros.h"
#import "Session.h"
#import "Ship.h"
#import "LEBuildingGetShipsFor.h"
#import "LEBuildingSendShip.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellShip.h"
#import "ViewPublicEmpireProfileController.h"


typedef enum {
	SECTION_SEND_TO
} SECTIONS;

typedef enum {
	ROW_SHIP_INFO,
	ROW_TRAVEL_TIME
} ROW;


@interface SendShipController(PrivateMethods)

- (void)sendShip;

@end


@implementation SendShipController


@synthesize availableShips;
@synthesize shipTravelTimes;
@synthesize mapItem;
@synthesize sendFromBodyId;
@synthesize selectedShip;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Send Ship";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	if (self.sendFromBodyId) {
		if ([self.mapItem.type isEqualToString:@"star"]) {
			[[[LEBuildingGetShipsFor alloc] initWithCallback:@selector(shipsLoaded:) target:self fromBodyId:self.sendFromBodyId targetBodyName:nil targetBodyId:nil targetStarName:nil targetStarId:self.mapItem.id targetX:nil targetY:nil] autorelease];
		} else {
			[[[LEBuildingGetShipsFor alloc] initWithCallback:@selector(shipsLoaded:) target:self fromBodyId:self.sendFromBodyId targetBodyName:nil targetBodyId:self.mapItem.id targetStarName:nil targetStarId:nil targetX:nil targetY:nil] autorelease];
		}
	}
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.availableShips) {
		if ([self.availableShips count] > 0) {
			return [self.availableShips count] + 1;
		} else {
			return 2;
		}
	} else {
		return 2;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case SECTION_SEND_TO:
			return 1;
			break;
		default:
			if (self.availableShips) {
				if ([self.availableShips count] > 0) {
					return 2;
				} else {
					return 1;
				}
				
			} else {
				return 1;
			}
			break;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_SEND_TO:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		default:
			if (self.availableShips) {
				if ([self.availableShips count] > 0) {
					switch (indexPath.row) {
						case ROW_SHIP_INFO:
							return [LETableViewCellShip getHeightForTableView:tableView];
							break;
						case ROW_TRAVEL_TIME:
							return [LETableViewCellLabeledText getHeightForTableView:tableView];
							break;
						default:
							return 0.0;
							break;
					}
				} else {
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
				}
				
			} else {
				return [LETableViewCellLabeledText getHeightForTableView:tableView];
			}
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
			if (self.sendFromBodyId) {
				Session *session = [Session sharedInstance];
				[session.empire.planets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
					if ([[obj objectForKey:@"id"] isEqualToString:self.sendFromBodyId]) {
						selectColonyButton.textLabel.text = [obj objectForKey:@"name"];
						*stop = YES;
					}
				}];
			} else {
				selectColonyButton.textLabel.text = @"Select Colony";
			}
			cell = selectColonyButton;
			break;
		default:
			if (self.availableShips) {
				if ([self.availableShips count] > 0) {
					Ship *currentShip = [self.availableShips objectAtIndex:(indexPath.section-1)];
					switch (indexPath.row) {
						case ROW_SHIP_INFO:
							; //DO NOT REMOVE
							LETableViewCellShip *shipInfoCell = [LETableViewCellShip getCellForTableView:tableView isSelectable:YES];
							[shipInfoCell setShip:currentShip];
							cell = shipInfoCell;
							break;
						case ROW_TRAVEL_TIME:
							; //DO NOT REMOVE
							LETableViewCellLabeledText *travelTimeCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
							travelTimeCell.label.text = @"Travel Time";
							travelTimeCell.content.text = [Util prettyDuration:_intv([self.shipTravelTimes objectForKey:currentShip.id])];
							cell = travelTimeCell;
							break;
						default:
							cell = nil;
							break;
					}
				} else {
					LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					loadingCell.label.text = @"Available Ships";
					loadingCell.content.text = @"None";
					cell = loadingCell;
				}
				
			} else {
				LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				loadingCell.label.text = @"Available Ships";
				loadingCell.content.text = @"Loading";
				cell = loadingCell;
			}
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
		default:
			if (self.availableShips) {
				if ([self.availableShips count] > 0) {
					self.selectedShip = [self.availableShips objectAtIndex:(indexPath.section-1)];
					Session *session = [Session sharedInstance];
					if (session.empire.isIsolationist && ([self.selectedShip.type isEqualToString:@"colony_ship"] || [self.selectedShip.type isEqualToString:@"short_range_colony_ship"])) {
						UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sending out a Colony Ship or Short Range Colongy Ship will take you out of Isolationist mode. This means spies can be sent to your Colonies." message:@"Are you sure you want to do this?" preferredStyle:UIAlertControllerStyleAlert];
						UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
							[self sendShip];
						}];
						UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
						}];
						[alert addAction:cancelAction];
						[alert addAction:okAction];
						[self presentViewController:alert animated:YES completion:nil];
					} else {
						[self sendShip];
					}
				}
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
	self.availableShips = nil;
	self.shipTravelTimes = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.availableShips = nil;
	self.shipTravelTimes = nil;
	self.mapItem = nil;
	self.sendFromBodyId = nil;
	[self->pickColonyController release];
	self->pickColonyController = nil;
	self.selectedShip = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark PickColonyDelegate Methods

- (void)colonySelected:(NSString *)colonyId {
	self.sendFromBodyId = colonyId;
	[self dismissViewControllerAnimated:YES completion:nil];
	[self->pickColonyController release];
	self->pickColonyController = nil;
	if ([self.mapItem.type isEqualToString:@"star"]) {
		[[[LEBuildingGetShipsFor alloc] initWithCallback:@selector(shipsLoaded:) target:self fromBodyId:self.sendFromBodyId targetBodyName:nil targetBodyId:nil targetStarName:nil targetStarId:self.mapItem.id targetX:nil targetY:nil] autorelease];
	} else {
		[[[LEBuildingGetShipsFor alloc] initWithCallback:@selector(shipsLoaded:) target:self fromBodyId:self.sendFromBodyId targetBodyName:nil targetBodyId:self.mapItem.id targetStarName:nil targetStarId:nil targetX:nil targetY:nil] autorelease];
	}
	self.availableShips = nil;
	self.shipTravelTimes = nil;
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Callback Methods

- (void)shipsLoaded:(LEBuildingGetShipsFor *)request {
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[request.available count]];
	NSMutableDictionary *tmpTravelTimes = [NSMutableDictionary dictionaryWithCapacity:[request.available count]];
	for (NSMutableDictionary *shipData in request.available) {
		Ship *ship = [[Ship alloc] init];
		[ship parseData:shipData];
		[tmp addObject:ship];
		NSDecimalNumber *estimatedTravelTime = [shipData objectForKey:@"estimated_travel_time"];
		if (isNull(estimatedTravelTime)) {
			estimatedTravelTime = [NSDecimalNumber zero];
		}
		[tmpTravelTimes setObject:estimatedTravelTime forKey:ship.id];
		[ship release];
	}
	self.availableShips = tmp;
	self.shipTravelTimes = tmpTravelTimes;
	[self.tableView reloadData];
}

- (void)shipLaunched:(LEBuildingSendShip *)request {
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark PrivateMethods

- (void)sendShip {
	if ([self.mapItem.type isEqualToString:@"star"]) {
		[[[LEBuildingSendShip alloc] initWithCallback:@selector(shipLaunched:) target:self shipId:self.selectedShip.id targetBodyName:nil targetBodyId:nil targetStarName:nil targetStarId:self.mapItem.id targetX:nil targetY:nil] autorelease];
	} else {
		[[[LEBuildingSendShip alloc] initWithCallback:@selector(shipLaunched:) target:self shipId:self.selectedShip.id targetBodyName:nil targetBodyId:self.mapItem.id targetStarName:nil targetStarId:nil targetX:nil targetY:nil] autorelease];
	}
}


#pragma mark -
#pragma mark Class Methods

+ (SendShipController *)create {
	return [[[SendShipController alloc] init] autorelease];
}


@end

