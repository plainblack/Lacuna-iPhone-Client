//
//  ViewUniverseOrbitingShipsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/24/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "ViewUniverseOrbitingShipsController.h"
#import "Util.h"
#import "Session.h"
#import "Ship.h"
#import "LEBuildingGetShipsFor.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellShip.h"
#import "LETableViewCellShipOrbitingTime.h"
#import "ViewPublicEmpireProfileController.h"
#import "LETableViewCellParagraph.h"


typedef enum {
	ROW_SHIP_INFO,
	ROW_TRAVELLING_INFO,
	ROW_PAYLOAD
} ROW;


@implementation ViewUniverseOrbitingShipsController


@synthesize orbitingShips;
@synthesize mapItem;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Orbiting Ships";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	Session *session = [Session sharedInstance];
	if ([self.mapItem.type isEqualToString:@"star"]) {
		[[[LEBuildingGetShipsFor alloc] initWithCallback:@selector(shipsLoaded:) target:self fromBodyId:session.body.id targetBodyName:nil targetBodyId:nil targetStarName:nil targetStarId:self.mapItem.id targetX:nil targetY:nil] autorelease];
	} else {
		[[[LEBuildingGetShipsFor alloc] initWithCallback:@selector(shipsLoaded:) target:self fromBodyId:session.body.id targetBodyName:nil targetBodyId:self.mapItem.id targetStarName:nil targetStarId:nil targetX:nil targetY:nil] autorelease];
	}
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return MAX(1, [self.orbitingShips count]);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.orbitingShips) {
		if ([self.orbitingShips count] > 0) {
			return 3;
		} else {
			return 1;
		}
		
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.orbitingShips) {
		if ([self.orbitingShips count] > 0) {
			Ship *currentShip = [self.orbitingShips objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_SHIP_INFO:
					return [LETableViewCellShip getHeightForTableView:tableView];
					break;
				case ROW_TRAVELLING_INFO:
					return [LETableViewCellShipOrbitingTime getHeightForTableView:tableView];
					break;
				case ROW_PAYLOAD:
					return [LETableViewCellParagraph getHeightForTableView:tableView text:[NSString stringWithFormat:@"Payload: %@", [currentShip prettyPayload]]];
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
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
	if (self.orbitingShips) {
		if ([self.orbitingShips count] > 0) {
			Ship *currentShip = [self.orbitingShips objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_SHIP_INFO:
					; //DO NOT REMOVE
					LETableViewCellShip *shipInfoCell = [LETableViewCellShip getCellForTableView:tableView isSelectable:NO];
					[shipInfoCell setShip:currentShip];
					cell = shipInfoCell;
					break;
				case ROW_TRAVELLING_INFO:
					; //DO NOT REMOVE
					LETableViewCellShipOrbitingTime *travellingInfoCell = [LETableViewCellShipOrbitingTime getCellForTableView:tableView];
					[travellingInfoCell setShip:currentShip];
					cell = travellingInfoCell;
					break;
				case ROW_PAYLOAD:
					; //DO NOT REMOVE
					LETableViewCellParagraph *payloadCell = [LETableViewCellParagraph getCellForTableView:tableView];
					payloadCell.content.text = [NSString stringWithFormat:@"Payload: %@", [currentShip prettyPayload]];
					cell = payloadCell;
					break;
				default:
					cell = nil;
					break;
			}
		} else {
			LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			loadingCell.label.text = @"Incoming Ships";
			loadingCell.content.text = @"None";
			cell = loadingCell;
		}
		
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Incoming Ships";
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
	self.orbitingShips = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.orbitingShips = nil;
	self.mapItem = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callback Methods

- (void)shipsLoaded:(LEBuildingGetShipsFor *)request {
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[request.incoming count]];
	for (NSMutableDictionary *shipData in request.orbiting) {
		Ship *ship = [[Ship alloc] init];
		[ship parseData:shipData];
		[tmp addObject:ship];
		[ship release];
	}
	self.orbitingShips = tmp;
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewUniverseOrbitingShipsController *)create {
	return [[[ViewUniverseOrbitingShipsController alloc] init] autorelease];
}


@end
