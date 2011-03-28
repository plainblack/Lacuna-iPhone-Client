//
//  SendFleetController.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/8/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "SendFleetController.h"
#import "Util.h"
#import "LEMacros.h"
#import "Session.h"
#import "Ship.h"
#import "LEViewSectionTab.h"
#import "LEBuildingGetShipsFor.h"
#import "LEBuildingSendFleet.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellShip.h"
#import "ViewPublicEmpireProfileController.h"


typedef enum {
	SECTION_SEND_TO,
	SECTION_FLEET,
} SECTIONS;

typedef enum {
	ROW_SHIP_INFO,
	ROW_TRAVEL_TIME
} ROW;


@interface SendFleetController(PrivateMethods)

- (void)sendFleet;

@end


@implementation SendFleetController


@synthesize availableShips;
@synthesize shipTravelTimes;
@synthesize mapItem;
@synthesize sendFromBodyId;
@synthesize selectedShip;
@synthesize fleetShips;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Build Fleet";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(sendFleet)] autorelease];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Send From"], [LEViewSectionTab tableView:self.tableView withText:@"Fleet To Send"]);
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
	if (!self.fleetShips) {
		self.fleetShips = [NSMutableArray arrayWithCapacity:5];
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
			return [self.availableShips count] + 2;
		} else {
			return 3;
		}
	} else {
		return 3;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case SECTION_SEND_TO:
			return 1;
			break;
		case SECTION_FLEET:
			return MAX(1, [self.fleetShips count]);
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
		case SECTION_FLEET:
			if ([self.fleetShips count] > 0) {
				return [LETableViewCellShip getHeightForTableView:tableView];
			} else {
				return [LETableViewCellLabeledText getHeightForTableView:tableView];
			}
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
		case SECTION_FLEET:
			if ([self.fleetShips count] > 0) {
				Ship *currentFleetShip = [self.fleetShips objectAtIndex:(indexPath.row)];
				LETableViewCellShip *shipInfoCell = [LETableViewCellShip getCellForTableView:tableView isSelectable:NO];
				[shipInfoCell setShip:currentFleetShip];
				cell = shipInfoCell;
			} else {
				LETableViewCellLabeledText *noFleetShipsCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				noFleetShipsCell.label.text = @"Fleet Ships";
				noFleetShipsCell.content.text = @"Select Ships Below";
				cell = noFleetShipsCell;
			}
			break;
		default:
			if (self.availableShips) {
				if ([self.availableShips count] > 0) {
					Ship *currentShip = [self.availableShips objectAtIndex:(indexPath.section-2)];
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
			[self presentModalViewController:self->pickColonyController animated:YES];
			break;
		default:
			if (self.availableShips) {
				if ([self.availableShips count] > 0) {
					self.selectedShip = [self.availableShips objectAtIndex:(indexPath.section-2)];
					Session *session = [Session sharedInstance];
					if (session.empire.isIsolationist && ([self.selectedShip.type isEqualToString:@"colony_ship"] || [self.selectedShip.type isEqualToString:@"short_range_colony_ship"])) {
						UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sending out a Colony Ship or Short Range Colongy Ship will take you out of Isolationist mode. This means spies can be sent to your Colonies. Are you sure you want to do this?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
						actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
						[actionSheet showFromTabBar:self.tabBarController.tabBar];
						[actionSheet release];
					} else {
						[self.fleetShips addObject:self.selectedShip];
						[self.availableShips removeObject:self.selectedShip];
						[tableView reloadData];
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
	[self dismissModalViewControllerAnimated:YES];
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


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_FLEET:
			return [self.fleetShips count] > 0 && indexPath.row < [self.fleetShips count];
			break;
		default:
			return NO;
			break;
	}
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ( ([self.fleetShips count] > 0 && indexPath.row < [self.fleetShips count]) && (editingStyle == UITableViewCellEditingStyleDelete) ) {
		Ship *ship = [self.fleetShips objectAtIndex:indexPath.row];
		[self.availableShips addObject:ship];
		[self.fleetShips removeObject:ship];
		[tableView reloadData];
	}
}


#pragma mark -
#pragma mark UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.destructiveButtonIndex == buttonIndex ) {
		[self.fleetShips addObject:self.selectedShip];
		[self.availableShips removeObject:self.selectedShip];
		[self.tableView reloadData];
	}
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

- (void)shipLaunched:(LEBuildingSendFleet *)request {
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark PrivateMethods

- (void)sendFleet {
	NSMutableArray *fleetShipIds = [NSMutableArray arrayWithCapacity:[self.fleetShips count]];
	[self.fleetShips enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		Ship *ship = (Ship *)obj;
		[fleetShipIds addObject:ship.id];
	}];
	
	if ([self.mapItem.type isEqualToString:@"star"]) {
		[[[LEBuildingSendFleet alloc] initWithCallback:@selector(shipLaunched:) target:self shipIds:fleetShipIds targetBodyName:nil targetBodyId:nil targetStarName:nil targetStarId:self.mapItem.id targetX:nil targetY:nil] autorelease];
	} else {
		[[[LEBuildingSendFleet alloc] initWithCallback:@selector(shipLaunched:) target:self shipIds:fleetShipIds targetBodyName:nil targetBodyId:self.mapItem.id targetStarName:nil targetStarId:nil targetX:nil targetY:nil] autorelease];
	}
}


#pragma mark -
#pragma mark Class Methods

+ (SendFleetController *)create {
	return [[[SendFleetController alloc] init] autorelease];
}


@end

