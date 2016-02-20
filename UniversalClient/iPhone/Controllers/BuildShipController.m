//
//  BuildShipController.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "BuildShipController.h"
#import "Util.h"
#import "Session.h"
#import "Shipyard.h"
#import "BuildableShip.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellBuildableShipInfo.h"
#import "LETableViewCellCost.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellUnbuildable.h"
#import "LETableViewCellParagraph.h"
#import "WebPageController.h"


typedef enum {
	ROW_BUILDABLE_SHIP,
	ROW_SHIP_COST,
	ROW_DESCRIPTION,
	ROW_WIKI_BUTTON,
	ROW_BUILD_BUTTON
} ROW;


@implementation BuildShipController


@synthesize shipyard;
@synthesize tag;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Build Ship";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.shipyard addObserver:self forKeyPath:@"buildableShips" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self.shipyard loadBuildableShipsForType:self.tag];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.shipyard removeObserver:self forKeyPath:@"buildableShips"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.shipyard && self.shipyard.buildableShips) {
		if ([self.shipyard.buildableShips count] > 0) {
			return [self.shipyard.buildableShips count];
		} else {
			return 1;
		}
		
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.shipyard && self.shipyard.buildableShips) {
		if ([self.shipyard.buildableShips count] > 0) {
			return 5;
		} else {
			return 1;
		}
		
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.shipyard && self.shipyard.buildableShips) {
		if ([self.shipyard.buildableShips count] > 0) {
			BuildableShip *currentShip = [self.shipyard.buildableShips objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_BUILDABLE_SHIP:
					return [LETableViewCellBuildableShipInfo getHeightForTableView:tableView];
					break;
				case ROW_SHIP_COST:
					return [LETableViewCellCost getHeightForTableView:tableView];
				case ROW_DESCRIPTION:
					; //DO NOT REMOVE
					Session *session = [Session sharedInstance];
					return [LETableViewCellParagraph getHeightForTableView:tableView text:[session descriptionForShip:currentShip.type]];
					break;
				case ROW_WIKI_BUTTON:
					return [LETableViewCellButton getHeightForTableView:tableView];
					break;
				case ROW_BUILD_BUTTON:
					if (currentShip.canBuild) {
						return [LETableViewCellButton getHeightForTableView:tableView];
					} else {
						return [LETableViewCellUnbuildable getHeightForTableView:tableView];
					}
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
	
	if (self.shipyard && self.shipyard.buildableShips) {
		if ([self.shipyard.buildableShips count] > 0) {
			BuildableShip *currentShip = [self.shipyard.buildableShips objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_BUILDABLE_SHIP:
					; //DO NOT REMOVE
					LETableViewCellBuildableShipInfo *shipBuildQueueCell = [LETableViewCellBuildableShipInfo getCellForTableView:tableView];
					[shipBuildQueueCell setBuildableShip:currentShip];
					cell = shipBuildQueueCell;
					break;
				case ROW_SHIP_COST:
					; //DO NOT REMOVE
					LETableViewCellCost *shipCostCell = [LETableViewCellCost getCellForTableView:tableView];
					[shipCostCell setResourceCost:currentShip.buildCost];
					cell = shipCostCell;
					break;
				case ROW_DESCRIPTION:
					; //DO NOT REMOVE
					Session *session = [Session sharedInstance];
					NSString *description = [session descriptionForShip:currentShip.type];
					LETableViewCellParagraph *descriptionCell = [LETableViewCellParagraph getCellForTableView:tableView];
					descriptionCell.content.text = description;
					cell = descriptionCell;
					break;
				case ROW_WIKI_BUTTON:
					; //DO NOT REMOVE
					LETableViewCellButton *wikiCell = [LETableViewCellButton getCellForTableView:tableView];
					wikiCell.textLabel.text = @"View Wiki Page";
					cell = wikiCell;
					break;
				case ROW_BUILD_BUTTON:
					if (currentShip.canBuild) {
						LETableViewCellButton *buildShipCell = [LETableViewCellButton getCellForTableView:tableView];
						buildShipCell.textLabel.text = @"Build";
						cell = buildShipCell;
					} else {
						LETableViewCellUnbuildable *unbuildableCell = [LETableViewCellUnbuildable getCellForTableView:tableView];
						if ([currentShip.reason isKindOfClass:[NSArray class]]) {
							[unbuildableCell setReason:[NSString stringWithFormat:@"%@", [currentShip.reason objectAtIndex:1]]];
						} else {
							[unbuildableCell setReason:[NSString stringWithFormat:@"%@", currentShip.reason]];
						}
						cell = unbuildableCell;
					}
					break;
				default:
					cell = nil;
					break;
			}
		} else {
			LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			loadingCell.label.text = @"Buildable";
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
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.shipyard && self.shipyard.buildableShips) {
		if ([self.shipyard.buildableShips count] > 0) {
			BuildableShip *currentShip = [self.shipyard.buildableShips objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_WIKI_BUTTON:
					; //DO NOT REMOVE
					Session *session = [Session sharedInstance];
					NSString *url = [session wikiLinkForShip:currentShip.type];
					NSLog(@"WIKI URL: %@", url);
					WebPageController *webPageController = [WebPageController create];
					webPageController.urlToLoad = url;
					[self presentViewController:webPageController animated:YES completion:nil];
					break;
				case ROW_BUILD_BUTTON:
					if (currentShip.canBuild) {
						[self.shipyard buildShipOfType:currentShip.type];
						[self.navigationController popViewControllerAnimated:YES];
					}
					break;
			}
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
	self.shipyard = nil;
	self.tag = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Class Methods

+ (BuildShipController *)create {
	return [[[BuildShipController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"buildableShips"]) {
		self.navigationItem.title = [NSString stringWithFormat:@"%@ Docks Available", self.shipyard.docksAvailable];
		[self.tableView reloadData];
	}
}


@end

