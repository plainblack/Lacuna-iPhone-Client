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


typedef enum {
	ROW_SHIP_INFO,
	ROW_RENAME_BUTTON,
	ROW_SCUTTLE_BUTTON
} ROW;


@implementation ViewShipsController


@synthesize spacePort;
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
		[self.spacePort loadShips];
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
	if (self.spacePort && self.spacePort.ships) {
		return [self.spacePort.ships count];
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.spacePort && self.spacePort.ships) {
		return 3;
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.spacePort && self.spacePort.ships) {
		switch (indexPath.row) {
			case ROW_SHIP_INFO:
				return [LETableViewCellShip getHeightForTableView:tableView];
				break;
			case ROW_RENAME_BUTTON:
			case ROW_SCUTTLE_BUTTON:
				return [LETableViewCellButton getHeightForTableView:tableView];
				break;
			default:
				return tableView.rowHeight;
				break;
		}
	} else {
		return [LETableViewCellLabeledText getHeightForTableView:tableView];
	}

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	
	if (self.spacePort && self.spacePort.ships) {
		Ship *currentShip = [self.spacePort.ships objectAtIndex:indexPath.section];
		switch (indexPath.row) {
			case ROW_SHIP_INFO:
				; //DO NOT REMOVE
				LETableViewCellShip *infoCell = [LETableViewCellShip getCellForTableView:tableView];
				[infoCell setShip:currentShip];
				cell = infoCell;
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
			default:
				break;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView];
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
				UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Scuttle ship?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
				actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
				[actionSheet showFromTabBar:self.tabBarController.tabBar];
				[actionSheet release];
				break;
			case ROW_RENAME_BUTTON:
				; //DO NOT REMOVE
				RenameShipController *renameShipController = [RenameShipController create];
				renameShipController.spacePort = self.spacePort;
				renameShipController.ship = currentShip;
				renameShipController.nameCell.textField.text = ship.name;
				[self.navigationController pushViewController:renameShipController animated:YES];
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
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	self.spacePort = nil;
	self.ship = nil;
	self.shipsLastUpdated = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.destructiveButtonIndex == buttonIndex ) {
		[self.spacePort scuttleShip:self.ship];
		self.ship = nil;
	}
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
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
