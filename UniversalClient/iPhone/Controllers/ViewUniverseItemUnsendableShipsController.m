//
//  ViewUniverseItemUnsendableShipsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 10/14/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewUniverseItemUnsendableShipsController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "Ship.h"
#import "LEBuildingGetShipsFor.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellParagraph.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellShip.h"


typedef enum {
	SECTION_SEND_TO
} SECTIONS;

typedef enum {
	ROW_SHIP_INFO,
	ROW_REASON_CANNOT_SEND
} ROW;


@implementation ViewUniverseItemUnsendableShipsController


@synthesize unsendableShips;
@synthesize mapItem;
@synthesize sendFromBodyId;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Unsendable Ships";
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
	if (self.unsendableShips) {
		if ([self.unsendableShips count] > 0) {
			return [self.unsendableShips count] + 1;
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
			if (self.unsendableShips) {
				if ([self.unsendableShips count] > 0) {
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
			if (self.unsendableShips) {
				if ([self.unsendableShips count] > 0) {
					switch (indexPath.row) {
						case ROW_SHIP_INFO:
							return [LETableViewCellShip getHeightForTableView:tableView];
							break;
						case ROW_REASON_CANNOT_SEND:
							; //DO NOT REMOVE
							NSMutableDictionary *data =  [self.unsendableShips objectAtIndex:(indexPath.section - 1)];
							NSString *reason = [data objectForKey:@"reason"];
							return [LETableViewCellParagraph getHeightForTableView:tableView text:reason];
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
			if (self.unsendableShips) {
				if ([self.unsendableShips count] > 0) {
					NSMutableDictionary *data =  [self.unsendableShips objectAtIndex:(indexPath.section - 1)];
					switch (indexPath.row) {
						case ROW_SHIP_INFO:
							; //DO NOT REMOVE
							Ship *currentShip = [data objectForKey:@"ship"];
							LETableViewCellShip *shipInfoCell = [LETableViewCellShip getCellForTableView:tableView isSelectable:NO];
							[shipInfoCell setShip:currentShip];
							cell = shipInfoCell;
							break;
						case ROW_REASON_CANNOT_SEND:
							; //DO NOT REMOVE
							NSString *reason = [data objectForKey:@"reason"];
							LETableViewCellParagraph *reasonCell = [LETableViewCellParagraph getCellForTableView:tableView];
							reasonCell.content.text = reason;
							cell = reasonCell;
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
	self.unsendableShips = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.unsendableShips = nil;
	self.mapItem = nil;
	self.sendFromBodyId = nil;
	[self->pickColonyController release];
	self->pickColonyController = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark PickColonyDelegate Methods

- (void)colonySelected:(NSString *)colonyId {
	self.sendFromBodyId = colonyId;
	[self dismissViewControllerAnimated:YES completion:nil];
	[self->pickColonyController release];
	self->pickColonyController = nil;
	self.unsendableShips = nil;
	if ([self.mapItem.type isEqualToString:@"star"]) {
		[[[LEBuildingGetShipsFor alloc] initWithCallback:@selector(shipsLoaded:) target:self fromBodyId:self.sendFromBodyId targetBodyName:nil targetBodyId:nil targetStarName:nil targetStarId:self.mapItem.id targetX:nil targetY:nil] autorelease];
	} else {
		[[[LEBuildingGetShipsFor alloc] initWithCallback:@selector(shipsLoaded:) target:self fromBodyId:self.sendFromBodyId targetBodyName:nil targetBodyId:self.mapItem.id targetStarName:nil targetStarId:nil targetX:nil targetY:nil] autorelease];
	}
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Callback Methods

- (void)shipsLoaded:(LEBuildingGetShipsFor *)request {
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[request.unavailabe count]];
	for (NSMutableDictionary *data in request.unavailabe) {
		NSString *reason = [[data objectForKey:@"reason"] objectAtIndex:1];
		NSMutableDictionary *shipData = [data objectForKey:@"ship"];
		Ship *ship = [[Ship alloc] init];
		[ship parseData:shipData];
		[tmp addObject:_dict(reason, @"reason", ship, @"ship")];
		[ship release];
	}
	self.unsendableShips = tmp;
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Class Methods

+ (ViewUniverseItemUnsendableShipsController *)create {
	return [[[ViewUniverseItemUnsendableShipsController alloc] init] autorelease];
}


@end

