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
@synthesize requestData;
@synthesize urlPart;
@synthesize secondsPerResource;
@synthesize seconds;
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
	[self.energyCell setNumericValue:[NSNumber numberWithInt:0]];
	self.oreCell = [LETableViewCellNumberEntry getCellForTableView:self.tableView viewController:self];
	[self.oreCell setNumericValue:[NSNumber numberWithInt:0]];
	self.waterCell = [LETableViewCellNumberEntry getCellForTableView:self.tableView viewController:self];
	[self.waterCell setNumericValue:[NSNumber numberWithInt:0]];
	self.subsidizedCell = [LETableViewCellLabeledSwitch getCellForTableView:self.tableView];
	self.seconds = [NSNumber numberWithInt:0];
	[self.energyCell addObserver:self forKeyPath:@"numericValue" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	[self.oreCell addObserver:self forKeyPath:@"numericValue" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	[self.waterCell addObserver:self forKeyPath:@"numericValue" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	[self.subsidizedCell addObserver:self forKeyPath:@"isSelected" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
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
			cell = self.energyCell;
			break;
		case ROW_ORE:
			self.oreCell.label.text = @"Ore";
			cell = self.oreCell;
			break;
		case ROW_WATER:
			self.waterCell.label.text = @"Water";
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
			timeCell.content.text = [NSString stringWithFormat:@"%@ seconds", self.seconds];
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
	[self.energyCell removeObserver:self forKeyPath:@"numericValue"];
	[self.oreCell removeObserver:self forKeyPath:@"numericValue"];
	[self.waterCell removeObserver:self forKeyPath:@"numericValue"];
	self.energyCell = nil;
	self.oreCell = nil;
	self.waterCell = nil;
	self.subsidizedCell = nil;
	self.seconds = nil;
}


- (void)dealloc {
	self.buildingId = nil;
	self.requestData = nil;
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
	NSNumber *secondsRemaining = [[request.response objectForKey:@"result"] objectForKey:@"seconds_remaining"];
	NSMutableDictionary *recycleData = [self.requestData objectForKey:@"recycle"];
	[recycleData setObject:secondsRemaining forKey:@"seconds_remaining"];
	[recycleData setObject:[NSNumber numberWithBool:(intv_(secondsRemaining) == 0)] forKey:@"can"];
	[[self navigationController] popViewControllerAnimated:YES];
	return nil;
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	NSLog(@"observeValueForKeyPath called");
	if ( [keyPath isEqual:@"numericValue"] ) {
		if (self.subsidizedCell.isSelected) {
			self.seconds = [NSNumber numberWithInt:0];
			[self.tableView reloadData];
		} else {
			NSInteger totalAmount = 0;
			totalAmount += intv_(self.energyCell.numericValue);
			totalAmount += intv_(self.oreCell.numericValue);
			totalAmount += intv_(self.waterCell.numericValue);
			self.seconds = [NSNumber numberWithInt:(totalAmount * intv_(secondsPerResource))];
			[self.tableView reloadData];
		}
	} else if ( [keyPath isEqual:@"isSelected"] ) {
		if (self.subsidizedCell.isSelected) {
			NSLog(@"Set to 0");
			self.seconds = [NSNumber numberWithInt:0];
			[self.tableView reloadData];
		} else {
			NSLog(@"Set to sum");
			NSInteger totalAmount = 0;
			totalAmount += intv_(self.energyCell.numericValue);
			totalAmount += intv_(self.oreCell.numericValue);
			totalAmount += intv_(self.waterCell.numericValue);
			NSLog(@"totalAmount: %i", totalAmount);
			self.seconds = [NSNumber numberWithInt:(totalAmount * intv_(secondsPerResource))];
			[self.tableView reloadData];
		}
	}
}


#pragma mark -
#pragma mark Class Methods

+ (RecycleController *)create {
	return [[[RecycleController alloc] init] autorelease];
}


@end

