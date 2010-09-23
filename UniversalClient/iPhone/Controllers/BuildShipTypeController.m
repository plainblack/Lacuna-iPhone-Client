//
//  BuildShipTypeController.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/23/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "BuildShipTypeController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "Shipyard.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "BuildShipController.h"

typedef enum {
	ROW_COLONIZATION,
	ROW_EXPLORATION,
	ROW_INTELLIGENCE,
	ROW_MINING,
	ROW_TRADE,
	ROW_WAR,
	ROW_ALL
} INFRASTRCUTURE_ROW;


@implementation BuildShipTypeController


@synthesize shipyard;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Resources"], [LEViewSectionTab tableView:self.tableView withText:@"Infrastructure"], [LEViewSectionTab tableView:self.tableView withText:@"All"]);
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 7;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	
	switch (indexPath.row) {
		case ROW_COLONIZATION:
			; //DO NOT REMOVE
			LETableViewCellButton *colonizationButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			colonizationButtonCell.textLabel.text = @"Colonization";
			cell = colonizationButtonCell;
			break;
		case ROW_EXPLORATION:
			; //DO NOT REMOVE
			LETableViewCellButton *explorationButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			explorationButtonCell.textLabel.text = @"Exploration";
			cell = explorationButtonCell;
			break;
		case ROW_INTELLIGENCE:
			; //DO NOT REMOVE
			LETableViewCellButton *intelligenceButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			intelligenceButtonCell.textLabel.text = @"Intelligence";
			cell = intelligenceButtonCell;
			break;
		case ROW_MINING:
			; //DO NOT REMOVE
			LETableViewCellButton *miningButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			miningButtonCell.textLabel.text = @"Ships";
			cell = miningButtonCell;
			break;
		case ROW_TRADE:
			; //DO NOT REMOVE
			LETableViewCellButton *tradeButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			tradeButtonCell.textLabel.text = @"Trade";
			cell = tradeButtonCell;
			break;
		case ROW_WAR:
			; //DO NOT REMOVE
			LETableViewCellButton *warButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			warButtonCell.textLabel.text = @"War";
			cell = warButtonCell;
			break;
		case ROW_ALL:
			; //DO NOT REMOVE
			LETableViewCellButton *allButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			allButtonCell.textLabel.text = @"All Ships";
			cell = allButtonCell;
			break;
		default:
			cell = nil;
			break;
	}
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	BuildShipController *buildShipController = [BuildShipController create];
	buildShipController.shipyard = self.shipyard;
	switch (indexPath.row) {
		case ROW_COLONIZATION:
			buildShipController.tag = @"Colonization";
			break;
		case ROW_EXPLORATION:
			buildShipController.tag = @"Exploration";
			break;
		case ROW_INTELLIGENCE:
			buildShipController.tag = @"Intelligence";
			break;
		case ROW_MINING:
			buildShipController.tag = @"Mining";
			break;
		case ROW_TRADE:
			buildShipController.tag = @"Trade";
			break;
		case ROW_WAR:
			buildShipController.tag = @"War";
			break;
		case ROW_ALL:
			buildShipController.tag = @"";
			break;
		default:
			buildShipController.tag = @"";
			break;
	}
	
	[[self navigationController] pushViewController:buildShipController animated:YES];
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
    [super dealloc];
}


#pragma mark -
#pragma mark Class Methods

+ (BuildShipTypeController *)create {
	return [[[BuildShipTypeController alloc] init] autorelease];
}


@end

