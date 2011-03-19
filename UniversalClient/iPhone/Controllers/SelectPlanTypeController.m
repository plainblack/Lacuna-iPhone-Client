//
//  SelectPlanTypeController.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/19/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "SelectPlanTypeController.h"
#import "LEMacros.h"
#import "Util.h"
#import "SpaceStationLabA.h"
#import "LEBuildingMakePlan.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellPlanType.h"


@implementation SelectPlanTypeController


@synthesize spaceStationLab;
@synthesize delegate;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Select Plan Type";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Plan Types"]);
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.spaceStationLab.types sortUsingDescriptors:_array([[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease])];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.spaceStationLab.types count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LETableViewCellPlanType getHeightForTableView:tableView];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
    
    if (indexPath.row < [self.spaceStationLab.types count]) {
        NSMutableDictionary *planType = [self.spaceStationLab.types objectAtIndex:indexPath.row];
        LETableViewCellPlanType *chooseTypeCell = [LETableViewCellPlanType getCellForTableView:tableView];
        [chooseTypeCell setPlanType:planType];
        cell = chooseTypeCell;
    }
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.spaceStationLab.types count]) {
        NSMutableDictionary *planType = [self.spaceStationLab.types objectAtIndex:indexPath.row];
        [self.delegate selectedPlanType:planType];
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
	self.spaceStationLab = nil;
    self.delegate = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callback Methods

- (void)madePlan:(LEBuildingMakePlan *)request {
    if (![request wasError]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark -
#pragma mark Class Methods

+ (SelectPlanTypeController *)create {
	SelectPlanTypeController *selectPlanTypeController = [[[SelectPlanTypeController alloc] init] autorelease];
	return selectPlanTypeController;
}


@end
