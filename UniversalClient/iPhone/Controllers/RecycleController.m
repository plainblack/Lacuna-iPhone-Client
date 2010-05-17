//
//  RecycleController.m
//  UniversalClient
//
//  Created by Kevin Runde on 5/13/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "RecycleController.h"
#import "LEMacros.h"
#import "LEBuildingRecycle.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellNumberEntry.h"
#import "LETableViewCellLabeledText.h"


typedef enum {
	ROW_ENERGY,
	ROW_ORE,
	ROW_WATER,
	ROW_SUBSIDIZED,
	ROW_TIME
} ROW;


@implementation RecycleController


@synthesize buildingId;
@synthesize urlPart;
@synthesize secondsPerResource;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	self.navigationItem.title = @"Assign Spy";
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)] autorelease];
	
	self.sectionHeaders = array_([LEViewSectionTab tableView:self.tableView createWithText:@"Recycle"]);
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 5;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
		case ROW_ENERGY:
		case ROW_ORE:
		case ROW_WATER:
			return [LETableViewCellNumberEntry getHeightForTableView:tableView];
			break;
		case ROW_SUBSIDIZED:
			return tableView.rowHeight;
			break;
		case ROW_TIME:
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
			break;
		default:
			return 5;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    switch (indexPath.row) {
		case ROW_ENERGY:
			; //DO NOT REMOVE
			LETableViewCellNumberEntry *energyCell = [LETableViewCellNumberEntry getCellForTableView:tableView viewController:self];
			energyCell.label.text = @"Energy";
			[energyCell setNumericValue:[NSNumber numberWithInt:0]];
			cell = energyCell;
			break;
		case ROW_ORE:
			; //DO NOT REMOVE
			LETableViewCellNumberEntry *oreCell = [LETableViewCellNumberEntry getCellForTableView:tableView viewController:self];
			oreCell.label.text = @"Ore";
			[oreCell setNumericValue:[NSNumber numberWithInt:0]];
			cell = oreCell;
			break;
		case ROW_WATER:
			; //DO NOT REMOVE
			LETableViewCellNumberEntry *waterCell = [LETableViewCellNumberEntry getCellForTableView:tableView viewController:self];
			waterCell.label.text = @"Water";
			[waterCell setNumericValue:[NSNumber numberWithInt:0]];
			cell = waterCell;
			break;
		case ROW_SUBSIDIZED:
			; //DO NOT REMOVE
			LETableViewCellLabeledText *subsidizedCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			subsidizedCell.content.text = @"Subsidized";
			cell = subsidizedCell;
			break;
		case ROW_TIME:
			; //DO NOT REMOVE
			LETableViewCellLabeledText *timeCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			timeCell.label.text = @"Time needed";
			timeCell.content.text = @"0 seconds";
			cell = timeCell;
			break;
		default:
			cell = nil;
			break;
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
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	self.buildingId = nil;
	self.urlPart = nil;
	self.secondsPerResource = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (void)cancel {
	[[self navigationController] popViewControllerAnimated:YES];
}


- (void)save {
	[[[LEBuildingRecycle alloc] initWithCallback:@selector(recyclStarted:) target:self buildingId:self.buildingId buildingUrl:self.urlPart energy:[NSNumber numberWithInt:1] ore:[NSNumber numberWithInt:1] water:[NSNumber numberWithInt:1] subsidized:NO] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (id)recyclStarted:(LEBuildingRecycle *)request {
	[[self navigationController] popViewControllerAnimated:YES];
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (RecycleController *)create {
	return [[[RecycleController alloc] init] autorelease];
}


@end

