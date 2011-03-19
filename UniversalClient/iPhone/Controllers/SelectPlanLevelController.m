//
//  SelectPlanLevelController.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/19/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "SelectPlanLevelController.h"
#import "LEMacros.h"
#import "Util.h"
#import "SpaceStationLabA.h"
#import "LEBuildingMakePlan.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellPlanLevel.h"


@implementation SelectPlanLevelController


@synthesize spaceStationLab;
@synthesize delegate;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Select Plan Level";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Plan Levels"]);
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.spaceStationLab.levels sortUsingDescriptors:_array([[[NSSortDescriptor alloc] initWithKey:@"level" ascending:YES] autorelease])];
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
	return [self.spaceStationLab.levels count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LETableViewCellPlanLevel getHeightForTableView:tableView];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
    
    if (indexPath.row < [self.spaceStationLab.levels count]) {
        NSMutableDictionary *planLevel = [self.spaceStationLab.levels objectAtIndex:indexPath.row];
        LETableViewCellPlanLevel *chooseLevelCell = [LETableViewCellPlanLevel getCellForTableView:tableView];
        [chooseLevelCell setPlanLevel:planLevel];
        cell = chooseLevelCell;
    }
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.spaceStationLab.levels count]) {
        NSMutableDictionary *planLevel = [self.spaceStationLab.levels objectAtIndex:indexPath.row];
        [self.delegate selectedPlanLevel:planLevel];
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

+ (SelectPlanLevelController *)create {
	SelectPlanLevelController *selectPlanLevelController = [[[SelectPlanLevelController alloc] init] autorelease];
	return selectPlanLevelController;
}


@end
