//
//  ViewForeignShipsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/12/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewForeignShipsController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Ship.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellShip.h"
#import "LETableViewCellForeignIncomingShip.h"
#import "LETableViewCellParagraph.h"


typedef enum {
	ROW_SHIP_INFO,
	ROW_FOREIGN_INFO,
	ROW_PAYLOAD,
} ROW;


@interface ViewForeignShipsController (PrivateMethods)

- (void)togglePageButtons;

@end


@implementation ViewForeignShipsController


@synthesize pageSegmentedControl;
@synthesize shipIntel;
@synthesize lastUpdated;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Incoming Ships";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.pageSegmentedControl = [[[UISegmentedControl alloc] initWithItems:_array(UP_ARROW_ICON, DOWN_ARROW_ICON)] autorelease];
	[self.pageSegmentedControl addTarget:self action:@selector(switchPage) forControlEvents:UIControlEventValueChanged]; 
	self.pageSegmentedControl.momentary = YES;
	UIBarButtonItem *rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.pageSegmentedControl] autorelease];
	self.navigationItem.rightBarButtonItem = rightBarButtonItem; 
	
	self.sectionHeaders = [NSArray array];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.shipIntel addObserver:self forKeyPath:@"foreignShipsUpdated" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	if (!self.shipIntel.foreignShips) {
		[self.shipIntel loadForeignShipsForPage:1];
	} else {
		if (self.lastUpdated) {
			if ([self.lastUpdated compare:self.shipIntel.foreignShipsUpdated] == NSOrderedAscending) {
				[self.tableView reloadData];
				self.lastUpdated = self.shipIntel.foreignShipsUpdated;
			}
		} else {
			self.lastUpdated = self.shipIntel.foreignShipsUpdated;
		}
	}
	
	[self togglePageButtons];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.shipIntel removeObserver:self forKeyPath:@"foreignShipsUpdated"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.shipIntel && self.shipIntel.foreignShips) {
		if ([self.shipIntel.foreignShips count] > 0) {
			return [self.shipIntel.foreignShips count];
		} else {
			return 1;
		}
		
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.shipIntel && self.shipIntel.foreignShips) {
		if ([self.shipIntel.foreignShips count] > 0) {
			return 3;
		} else {
			return 1;
		}
		
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.shipIntel && self.shipIntel.foreignShips) {
		if ([self.shipIntel.foreignShips count] > 0) {
			Ship *currentShip = [self.shipIntel.foreignShips objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_SHIP_INFO:
					return [LETableViewCellShip getHeightForTableView:tableView];
					break;
				case ROW_FOREIGN_INFO:
					return [LETableViewCellForeignIncomingShip getHeightForTableView:tableView];
					break;
				case ROW_PAYLOAD:
					return [LETableViewCellParagraph getHeightForTableView:tableView text:[NSString stringWithFormat:@"Payload: %@", [currentShip prettyPayload]]];
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
	
	if (self.shipIntel && self.shipIntel.foreignShips) {
		if ([self.shipIntel.foreignShips count] > 0) {
			Ship *currentShip = [self.shipIntel.foreignShips objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_SHIP_INFO:
					; //DO NOT REMOVE
					LETableViewCellShip *shipInfoCell = [LETableViewCellShip getCellForTableView:tableView isSelectable:NO];
					[shipInfoCell setShip:currentShip];
					cell = shipInfoCell;
					break;
				case ROW_FOREIGN_INFO:
					; //DO NOT REMOVE
					LETableViewCellForeignIncomingShip *foreignInfoCell = [LETableViewCellForeignIncomingShip getCellForTableView:tableView];
					[foreignInfoCell setShip:currentShip];
					cell = foreignInfoCell;
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
			loadingCell.label.text = @"In Transit";
			loadingCell.content.text = @"None";
			cell = loadingCell;
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
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.pageSegmentedControl = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.pageSegmentedControl = nil;
	self.shipIntel = nil;
	self.lastUpdated = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callback Methods

- (void) switchPage {
	switch (self.pageSegmentedControl.selectedSegmentIndex) {
		case 0:
			[self.shipIntel loadForeignShipsForPage:(self.shipIntel.foreignShipsPageNumber-1)];
			break;
		case 1:
			[self.shipIntel loadForeignShipsForPage:(self.shipIntel.foreignShipsPageNumber+1)];
			break;
		default:
			NSLog(@"Invalid switchPage");
			break;
	}
}


#pragma mark -
#pragma mark Private Methods

- (void)togglePageButtons {
	[self.pageSegmentedControl setEnabled:[self.shipIntel hasPreviousForeignShipsPage] forSegmentAtIndex:0];
	[self.pageSegmentedControl setEnabled:[self.shipIntel hasNextForeignShipsPage] forSegmentAtIndex:1];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewForeignShipsController *)create {
	return [[[ViewForeignShipsController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"foreignShipsUpdated"]) {
		[self togglePageButtons];
		[self.tableView reloadData];
		self.lastUpdated = self.shipIntel.foreignShipsUpdated;
	}
}


@end

