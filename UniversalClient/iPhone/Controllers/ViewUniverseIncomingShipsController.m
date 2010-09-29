//
//  ViewUniverseIncomingShipsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewUniverseIncomingShipsController.h"
#import "Util.h"
#import "Session.h"
#import "Ship.h"
#import "LEBuildingGetShipsFor.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellShip.h"
#import "LETableViewCellTravellingShip.h"
#import "ViewPublicEmpireProfileController.h"


typedef enum {
	ROW_SHIP_INFO,
	ROW_TRAVELLING_INFO
} ROW;


@implementation ViewUniverseIncomingShipsController


@synthesize incomingShips;
@synthesize mapItem;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Incoming Ships";
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
	if (self.incomingShips) {
		if ([self.incomingShips count] > 0) {
			return [self.incomingShips count];
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.incomingShips) {
		if ([self.incomingShips count] > 0) {
			return 2;
		} else {
			return 1;
		}
		
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.incomingShips) {
		if ([self.incomingShips count] > 0) {
			switch (indexPath.row) {
				case ROW_SHIP_INFO:
					return [LETableViewCellShip getHeightForTableView:tableView];
					break;
				case ROW_TRAVELLING_INFO:
					return [LETableViewCellTravellingShip getHeightForTableView:tableView];
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
	UITableViewCell *cell;
	
	if (self.incomingShips) {
		if ([self.incomingShips count] > 0) {
			Ship *currentShip = [self.incomingShips objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_SHIP_INFO:
					; //DO NOT REMOVE
					LETableViewCellShip *shipInfoCell = [LETableViewCellShip getCellForTableView:tableView isSelectable:NO];
					[shipInfoCell setShip:currentShip];
					cell = shipInfoCell;
					break;
				case ROW_TRAVELLING_INFO:
					; //DO NOT REMOVE
					LETableViewCellTravellingShip *travellingInfoCell = [LETableViewCellTravellingShip getCellForTableView:tableView];
					[travellingInfoCell setShip:currentShip];
					cell = travellingInfoCell;
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
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.incomingShips) {
		if ([self.incomingShips count] > 0) {
			NSMutableDictionary *incomingShip = [self.incomingShips objectAtIndex:indexPath.row];
			ViewPublicEmpireProfileController *viewPublicEmpireProfileController = [ViewPublicEmpireProfileController create];
			viewPublicEmpireProfileController.empireId = [incomingShip objectForKey:@"empire_id"];
			[self.navigationController pushViewController:viewPublicEmpireProfileController animated:YES];
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
	self.incomingShips = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.incomingShips = nil;
	self.mapItem = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callback Methods

- (void)shipsLoaded:(LEBuildingGetShipsFor *)request {
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[request.incoming count]];
	for (NSMutableDictionary *shipData in request.incoming) {
		Ship *ship = [[Ship alloc] init];
		[ship parseData:shipData];
		[tmp addObject:ship];
		[ship release];
	}
	self.incomingShips = tmp;
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewUniverseIncomingShipsController *)create {
	return [[[ViewUniverseIncomingShipsController alloc] init] autorelease];
}


@end

