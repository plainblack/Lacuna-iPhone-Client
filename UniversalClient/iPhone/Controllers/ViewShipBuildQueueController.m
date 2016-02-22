//
//  ViewShipBuildQueueController.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewShipBuildQueueController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Shipyard.h"
#import "ShipBuildQueueItem.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellShipBuildQueueItem.h"


typedef enum {
	ROW_SHIP_BUILD_QUEUE_ITEM
} ROW;


@interface ViewShipBuildQueueController (PrivateMethods)

- (void)togglePageButtons;

@end


@implementation ViewShipBuildQueueController


@synthesize pageSegmentedControl;
@synthesize shipyard;


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Ship Build Queue";
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
	[self.shipyard addObserver:self forKeyPath:@"buildQueue" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self.shipyard loadBuildQueueForPage:1];

	[self togglePageButtons];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.shipyard removeObserver:self forKeyPath:@"buildQueue"];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.shipyard.buildQueue count] + 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.shipyard && self.shipyard.buildQueue) {
		if ([self.shipyard.buildQueue count] > 0) {
            if (indexPath.section < [self.shipyard.buildQueue count]) {
                switch (indexPath.row) {
                    case ROW_SHIP_BUILD_QUEUE_ITEM:
                        return [LETableViewCellShipBuildQueueItem getHeightForTableView:tableView];
                        break;
                    default:
                        return tableView.rowHeight;
                        break;
                }
            } else {
                return [LETableViewCellButton getHeightForTableView:tableView];
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
	
	if (self.shipyard && self.shipyard.buildQueue) {
		if ([self.shipyard.buildQueue count] > 0) {
            if (indexPath.section < [self.shipyard.buildQueue count]) {
                ShipBuildQueueItem *currentShip = [self.shipyard.buildQueue objectAtIndex:indexPath.section];
                switch (indexPath.row) {
                    case ROW_SHIP_BUILD_QUEUE_ITEM:
                        ; //DO NOT REMOVE
                        LETableViewCellShipBuildQueueItem *shipBuildQueueCell = [LETableViewCellShipBuildQueueItem getCellForTableView:tableView];
                        [shipBuildQueueCell setShipBuildQueueItem:currentShip];
                        cell = shipBuildQueueCell;
                        break;
                    default:
                        cell = nil;
                        break;
                }
            } else {
                LETableViewCellButton *subsidizeCell = [LETableViewCellButton getCellForTableView:tableView];
                subsidizeCell.textLabel.text = [NSString stringWithFormat:@"Subsidize (%@ essentia)", self.shipyard.subsidizeCost];
                cell = subsidizeCell;
            }
		} else {
			LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			loadingCell.label.text = @"Building";
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


#pragma mark - UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"TEST 1");
	if (self.shipyard && self.shipyard.buildQueue && indexPath.section >= [self.shipyard.buildQueue count]) {
        NSLog(@"TEST 2");
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Subsidizing the ship build queue will cost %@ essentia. Are you sure you want to do this?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
			[self.shipyard subsidizeBuildQueue];
		}];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
		}];
		[alert addAction:cancelAction];
		[alert addAction:okAction];
		[self presentViewController:alert animated:YES completion:nil];
    }
}


#pragma mark - Memory management

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
	self.shipyard = nil;
    [super dealloc];
}


#pragma mark - Callback Methods

- (void) switchPage {
	switch (self.pageSegmentedControl.selectedSegmentIndex) {
		case 0:
			[self.shipyard loadBuildQueueForPage:(self.shipyard.buildQueuePageNumber-1)];
			break;
		case 1:
			[self.shipyard loadBuildQueueForPage:(self.shipyard.buildQueuePageNumber+1)];
			break;
		default:
			NSLog(@"Invalid switchPage");
			break;
	}
}


#pragma mark - Private Methods

- (void)togglePageButtons {
	[self.pageSegmentedControl setEnabled:[self.shipyard hasPreviousBuildQueuePage] forSegmentAtIndex:0];
	[self.pageSegmentedControl setEnabled:[self.shipyard hasNextBuildQueuePage] forSegmentAtIndex:1];
}


#pragma mark - Class Methods

+ (ViewShipBuildQueueController *)create {
	return [[[ViewShipBuildQueueController alloc] init] autorelease];
}


#pragma mark - KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"buildQueue"]) {
		[self togglePageButtons];
		[self.tableView reloadData];
	}
}


@end

