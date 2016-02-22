//
//  ViewShips.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewShipsController.h"
#import "LEMacros.h"
#import "Util.h"
#import	"SpacePort.h"
#import "Ship.h"
#import "LETableViewCellShip.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "RenameShipController.h"
#import "AppDelegate_Phone.h"


typedef enum {
	ROW_SHIP_INFO,
	ROW_TASK,
	ROW_RENAME_BUTTON,
	ROW_SCUTTLE_BUTTON,
	ROW_LOCATION_BUTTON,
	ROW_RECALL_BUTTON,
} ROW;


@implementation ViewShipsController


@synthesize spacePort;
@synthesize task;
@synthesize tag;
@synthesize ship;
@synthesize shipsLastUpdated;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	
	self.navigationItem.title = @"Ships";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.spacePort addObserver:self forKeyPath:@"shipsUpdated" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	if (!self.spacePort.ships) {
		[self.spacePort loadShipsForTag:self.tag task:self.task];
	} else {
		if (self.shipsLastUpdated) {
			if ([self.shipsLastUpdated compare:self.spacePort.shipsUpdated] == NSOrderedAscending) {
				[self.tableView reloadData];
				self.shipsLastUpdated = self.spacePort.shipsUpdated;
			}
		} else {
			self.shipsLastUpdated = self.spacePort.shipsUpdated;
		}
	}
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.spacePort removeObserver:self forKeyPath:@"shipsUpdated"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return MAX(1, [self.spacePort.ships count]);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.spacePort && self.spacePort.ships) {
        if ([self.spacePort.ships count] > 0) {
            Ship *currentShip = [self.spacePort.ships objectAtIndex:section];
            if ([currentShip.task isEqualToString:@"Defend" ] || [currentShip.task isEqualToString:@"Orbiting" ]) {
                return 6;
            } else {
                return 4;
            }
        } else  {
            return 1;
        }
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.spacePort && self.spacePort.ships) {
        if ([self.spacePort.ships count] > 0) {
            switch (indexPath.row) {
                case ROW_SHIP_INFO:
                    return [LETableViewCellShip getHeightForTableView:tableView];
                    break;
                case ROW_TASK:
                    return [LETableViewCellLabeledText getHeightForTableView:tableView];
                    break;
                case ROW_LOCATION_BUTTON:
                case ROW_RENAME_BUTTON:
                case ROW_SCUTTLE_BUTTON:
                case ROW_RECALL_BUTTON:
                    return [LETableViewCellButton getHeightForTableView:tableView];
                    break;
                default:
                    return tableView.rowHeight;
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
	
	if (self.spacePort && self.spacePort.ships) {
        if ([self.spacePort.ships count] > 0) {
            Ship *currentShip = [self.spacePort.ships objectAtIndex:indexPath.section];
            switch (indexPath.row) {
                case ROW_SHIP_INFO:
                    ; //DO NOT REMOVE
                    LETableViewCellShip *infoCell = [LETableViewCellShip getCellForTableView:tableView isSelectable:NO];
                    [infoCell setShip:currentShip];
                    cell = infoCell;
                    break;
                case ROW_TASK:
                    ; //DO NOT REMOVE
                    LETableViewCellLabeledText *taskCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
                    taskCell.label.text = @"Task";
                    taskCell.content.text = currentShip.task;
                    cell = taskCell;
                    break;
                case ROW_RENAME_BUTTON:
                    ; //DO NOT REMOVE
                    LETableViewCellButton *renameButtonCell = [LETableViewCellButton getCellForTableView:tableView];
                    renameButtonCell.textLabel.text = @"Rename";
                    cell = renameButtonCell;
                    break;
                case ROW_SCUTTLE_BUTTON:
                    ; //DO NOT REMOVE
                    LETableViewCellButton *scuttleButtonCell = [LETableViewCellButton getCellForTableView:tableView];
                    scuttleButtonCell.textLabel.text = @"Scuttle";
                    cell = scuttleButtonCell;
                    break;
                case ROW_LOCATION_BUTTON:
                    ; //DO NOT REMOVE
                    LETableViewCellButton *locationButtonCell = [LETableViewCellButton getCellForTableView:tableView];
                    locationButtonCell.textLabel.text = [NSString stringWithFormat:@"At: %@", currentShip.orbitingName];
                    cell = locationButtonCell;
                    break;
                case ROW_RECALL_BUTTON:
                    ; //DO NOT REMOVE
                    LETableViewCellButton *recallButtonCell = [LETableViewCellButton getCellForTableView:tableView];
                    recallButtonCell.textLabel.text = @"Recall";
                    cell = recallButtonCell;
                    break;
                default:
                    break;
            }
        } else {
            LETableViewCellLabeledText *noneCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
            noneCell.label.text = @"Ships";
            noneCell.content.text = @"None Found";
            cell = noneCell;
        }
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"";
		loadingCell.content.text = @"Loading";
		cell = loadingCell;
	}
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.spacePort && self.spacePort.ships) {
		Ship *currentShip = [self.spacePort.ships objectAtIndex:indexPath.section];
		switch (indexPath.row) {
			case ROW_SCUTTLE_BUTTON:
				self.ship = currentShip;
				UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Scuttle ship?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
				UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
					[self.spacePort scuttleShip:self.ship];
					self.ship = nil;
				}];
				UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
				}];
				[alert addAction:cancelAction];
				[alert addAction:okAction];
				[self presentViewController:alert animated:YES completion:nil];
				[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
				break;
			case ROW_RECALL_BUTTON:
				[self.spacePort recallShip:currentShip];
				break;
			case ROW_RENAME_BUTTON:
				; //DO NOT REMOVE
				RenameShipController *renameShipController = [RenameShipController create];
				renameShipController.spacePort = self.spacePort;
				renameShipController.ship = currentShip;
				renameShipController.nameCell.textField.text = ship.name;
				[self.navigationController pushViewController:renameShipController animated:YES];
				break;
			case ROW_LOCATION_BUTTON:
				; //DO NOT REMOVE
				if (currentShip.orbitingX && currentShip.orbitingY) {
					AppDelegate_Phone *appDelegate = (AppDelegate_Phone *)[UIApplication sharedApplication].delegate;
					[appDelegate showStarMapGridX:currentShip.orbitingX gridY:currentShip.orbitingY];
				} else {
					UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"AARRGGHH!!" message:@"Need server to send orbiting X & Y" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
					[av show];
					[av release];
				}

				break;
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
    [super viewDidUnload];
}


- (void)dealloc {
	self.spacePort = nil;
	self.task = nil;
	self.tag = nil;
	self.ship = nil;
	self.shipsLastUpdated = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewShipsController *)create {
	return [[[ViewShipsController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"shipsUpdated"]) {
		[self.tableView reloadData];
		self.shipsLastUpdated = self.spacePort.shipsUpdated;
	}
}


@end

