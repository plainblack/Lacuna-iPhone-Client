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
#import "LETableViewCellLabeledSwitch.h"


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
@synthesize energyCell;
@synthesize oreCell;
@synthesize waterCell;
@synthesize subsidizedCell;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	self.navigationItem.title = @"Recycle";
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)] autorelease];
	
	self.sectionHeaders = array_([LEViewSectionTab tableView:self.tableView createWithText:@"Recycle"]);
	
	self.energyCell = [LETableViewCellNumberEntry getCellForTableView:self.tableView viewController:self];
	self.oreCell = [LETableViewCellNumberEntry getCellForTableView:self.tableView viewController:self];
	self.waterCell = [LETableViewCellNumberEntry getCellForTableView:self.tableView viewController:self];
	self.subsidizedCell = [LETableViewCellLabeledSwitch getCellForTableView:self.tableView];

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
			return [LETableViewCellLabeledSwitch getHeightForTableView:tableView];
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
			self.energyCell.label.text = @"Energy";
			[self.energyCell setNumericValue:[NSNumber numberWithInt:0]];
			cell = self.energyCell;
			break;
		case ROW_ORE:
			self.oreCell.label.text = @"Ore";
			[self.oreCell setNumericValue:[NSNumber numberWithInt:0]];
			cell = self.oreCell;
			break;
		case ROW_WATER:
			self.waterCell.label.text = @"Water";
			[self.waterCell setNumericValue:[NSNumber numberWithInt:0]];
			cell = self.waterCell;
			break;
		case ROW_SUBSIDIZED:
			; //DO NOT REMOVE
			self.subsidizedCell.label.text = @"Subsidized";
			cell = self.subsidizedCell;
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
	self.energyCell = nil;
	self.oreCell = nil;
	self.waterCell = nil;
	self.subsidizedCell = nil;
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
	[[[LEBuildingRecycle alloc] initWithCallback:@selector(recyclStarted:) target:self buildingId:self.buildingId buildingUrl:self.urlPart energy:[self.energyCell numericValue] ore:[self.oreCell numericValue] water:[self.waterCell numericValue] subsidized:[self.subsidizedCell isSelected]] autorelease];
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

