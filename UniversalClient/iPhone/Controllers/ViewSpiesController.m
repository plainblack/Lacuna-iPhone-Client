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

typedef enum {
	ROW_SPY_INFO,
	ROW_BURN_BUTTON,
	ROW_RENAME_BUTTON,
	ROW_ASSIGN_BUTTON,
	ROW_ASSIGNED
} ROW;


@implementation ViewSpiesController


@synthesize buildingId;
@synthesize spiesData;
@synthesize urlPart;
@synthesize spies;
@synthesize reloadTimer;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Spies";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = array_([LEViewSectionTab tableView:self.tableView createWithText:@"Spies"]);
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
	switch (indexPath.row) {
		case ROW_SPY_INFO:
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
			break;
		case ROW_BURN_BUTTON:
		case ROW_RENAME_BUTTON:
		case ROW_ASSIGN_BUTTON:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case ROW_ASSIGNED:
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
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
			LETableViewCellLabeledText *spyInfoCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			spyInfoCell.label.text = @"Spy";
			spyInfoCell.content.text = [spy objectForKey:@"name"];
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
			; //DO NOT REMOVE
			LETableViewCellButton *assignButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			assignButtonCell.textLabel.text = @"Assign spy";
			cell = assignButtonCell;
			break;
		case ROW_ASSIGNED:
			; //DO NOT REMOVE
			LETableViewCellLabeledText *assignedCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			assignedCell.label.text = @"Assignment";
			assignedCell.content.text = [spy objectForKey:@"assignment"];
			cell = assignedCell;
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
	NSDictionary *spy = [self.spies objectAtIndex:indexPath.section];
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
			NSLog(@"KEVIN MAKE ASSIGN WORK");
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
		NSInteger currentSpyCount = intv_([self.spiesData objectForKey:@"current"]);
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

