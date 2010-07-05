//
//  ViewSpiesController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewSpiesController.h"
#import "LEMacros.h"
#import "LEViewSectionTab.h"
#import "LEBuildingViewSpies.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LEBuildingBurnSpy.h"
#import "RenameSpyController.h"
#import "AssignSpyController.h"
#import "LETableViewCellSpyInfo.h"
#import "Util.h"


typedef enum {
	ROW_SPY_INFO,
	ROW_BURN_BUTTON,
	ROW_RENAME_BUTTON,
	ROW_ASSIGN_BUTTON
} ROW;


@implementation ViewSpiesController


@synthesize buildingId;
@synthesize spiesData;
@synthesize urlPart;
@synthesize spies;
@synthesize reloadTimer;
@synthesize possibleAssignments;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Spies";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView createWithText:@"Spies"]);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[[[LEBuildingViewSpies alloc] initWithCallback:@selector(spiesLoaded:) target:self buildingId:self.buildingId buildingUrl:self.urlPart] autorelease];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	self.reloadTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
}


- (void)viewDidDisappear:(BOOL)animated {
	[self.reloadTimer invalidate]; 
	self.reloadTimer = nil;
    [super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.spies count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *spy = [self.spies objectAtIndex:indexPath.section];
	switch (indexPath.row) {
		case ROW_SPY_INFO:
			return [LETableViewCellSpyInfo getHeightForTableView:tableView];
			break;
		case ROW_BURN_BUTTON:
		case ROW_RENAME_BUTTON:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case ROW_ASSIGN_BUTTON:
			if (_intv([spy objectForKey:@"is_available"]) == 1) {
				return [LETableViewCellButton getHeightForTableView:tableView];
			} else {
				return [LETableViewCellLabeledText getHeightForTableView:tableView];
			}
			break;
		default:
			return tableView.rowHeight;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *spy = [self.spies objectAtIndex:indexPath.section];
    
    UITableViewCell *cell;
	
	switch (indexPath.row) {
		case ROW_SPY_INFO:
			; //DO NOT REMOVE
			LETableViewCellSpyInfo *spyInfoCell = [LETableViewCellSpyInfo getCellForTableView:tableView];
			[spyInfoCell setData:spy];
			cell = spyInfoCell;
			break;
		case ROW_BURN_BUTTON:
			; //DO NOT REMOVE
			LETableViewCellButton *burnButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			burnButtonCell.textLabel.text = @"Burn spy";
			cell = burnButtonCell;
			break;
		case ROW_RENAME_BUTTON:
			; //DO NOT REMOVE
			LETableViewCellButton *renameButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			renameButtonCell.textLabel.text = @"Rename spy";
			cell = renameButtonCell;
			break;
		case ROW_ASSIGN_BUTTON:
			if (_intv([spy objectForKey:@"is_available"]) == 1) {
				LETableViewCellButton *assignButtonCell = [LETableViewCellButton getCellForTableView:tableView];
				assignButtonCell.textLabel.text = @"Assign spy";
				cell = assignButtonCell;
			} else {
				LETableViewCellLabeledText *assignedCell = [LETableViewCellLabeledText getCellForTableView:tableView];
				assignedCell.label.text = @"Busy until";
				assignedCell.content.text = [Util prettyDate:[spy objectForKey:@"available_on"]];
				cell = assignedCell;
			}
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
	NSMutableDictionary *spy = [self.spies objectAtIndex:indexPath.section];
	switch (indexPath.row) {
		case ROW_BURN_BUTTON:
			[[[LEBuildingBurnSpy alloc] initWithCallback:@selector(spyBurnt:) target:self buildingId:self.buildingId buildingUrl:self.urlPart spyId:[spy objectForKey:@"id"]] autorelease];
			break;
		case ROW_RENAME_BUTTON:
			; //DO NOT REMOVE
			RenameSpyController *renameSpyController = [RenameSpyController create];
			renameSpyController.buildingId = self.buildingId;
			renameSpyController.spyId = [spy objectForKey:@"id"];
			renameSpyController.urlPart = self.urlPart;
			renameSpyController.nameCell.textField.text = [spy objectForKey:@"name"];
			[self.navigationController pushViewController:renameSpyController animated:YES];
			break;
		case ROW_ASSIGN_BUTTON:
			if (_intv([spy objectForKey:@"is_available"]) == 1) {
				AssignSpyController *assignSpyController = [AssignSpyController create];
				assignSpyController.buildingId = self.buildingId;
				assignSpyController.spyData = spy;
				assignSpyController.urlPart = self.urlPart;
				assignSpyController.possibleAssignments = self.possibleAssignments;
				[self.navigationController pushViewController:assignSpyController animated:YES];
			}
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
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	[self.reloadTimer invalidate]; 
	self.reloadTimer = nil;
	self.spies = nil;
	self.possibleAssignments = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	self.buildingId = nil;
	self.spiesData = nil;
	self.urlPart = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callback Methods

- (void)handleTimer:(NSTimer *)theTimer {
	NSLog(@"handleTimer");
	if (theTimer == self.reloadTimer) {
		[[[LEBuildingViewSpies alloc] initWithCallback:@selector(spiesLoaded:) target:self buildingId:self.buildingId buildingUrl:self.urlPart] autorelease];
	}
}


- (id)spiesLoaded:(LEBuildingViewSpies *)request {
	self.spies = request.spies;
	self.possibleAssignments = request.possibleAssignments;
	NSLog(@"SPIES: %@", self.spies);
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[self.spies count]];
	for (NSDictionary *spy in self.spies) {
		[tmp addObject:[LEViewSectionTab tableView:self.tableView createWithText:[spy objectForKey:@"name"]]];
	}
	self.sectionHeaders = tmp;
	[self.tableView reloadData];
	
	return nil;
}


- (id)spyBurnt:(LEBuildingBurnSpy *)request {
	NSDictionary *spyToRemove;
	for (NSDictionary *spy in self.spies) {
		if ([[spy objectForKey:@"id"] isEqualToString:request.spyId]) {
			spyToRemove = spy;
		}
	}
	if (spyToRemove) {
		[self.spies removeObject:spyToRemove];
		NSInteger currentSpyCount = _intv([self.spiesData objectForKey:@"current"]);
		currentSpyCount -= 1;
		[self.spiesData setObject:[NSNumber numberWithInt:currentSpyCount] forKey:@"current"];
	}
	[self.tableView reloadData];
	
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (ViewSpiesController *)create {
	return [[[ViewSpiesController alloc] init] autorelease];
}


@end

