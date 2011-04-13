//
//  ChooseProposeTypeViewController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/9/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "ChooseProposeTypeViewController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "Parliament.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "ChooseWritTemplateViewController.h"
#import "ProposeFireBfgViewController.h"
#import "ProposeTransferStationOwnership.h"
#import "ProposeSeizeStarViewController.h"


typedef enum {
    ROW_WRIT,
    ROW_FIRE_BFG,
    ROW_SEIZE_STAR,
    ROW_TRANSFER_STATION_OWNERSHIP,
    ROW_COUNT,
} ROWS;


@implementation ChooseProposeTypeViewController


@synthesize parliament;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Propose";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Proposal Types"]);
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ROW_COUNT;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LETableViewCellButton getHeightForTableView:tableView];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LETableViewCellButton *button = [LETableViewCellButton getCellForTableView:tableView];
    
    switch (indexPath.row) {
        case ROW_WRIT:
            button.textLabel.text = @"Writ";
            break;
        case ROW_FIRE_BFG:
            button.textLabel.text = @"Fire BFG";
            break;
        case ROW_SEIZE_STAR:
            button.textLabel.text = @"Seize Star";
            break;
        case ROW_TRANSFER_STATION_OWNERSHIP:
            button.textLabel.text = @"Transfer Station Ownership";
            break;
        default:
            button.textLabel.text = @"???";
            break;
    }
    
    return button;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case ROW_WRIT:
            ; //DO NOT REMOVE
            ChooseWritTemplateViewController *chooseWritTemplateViewController = [ChooseWritTemplateViewController create];
            chooseWritTemplateViewController.parliament = self.parliament;
            [self.navigationController pushViewController:chooseWritTemplateViewController animated:YES];
            break;
        case ROW_FIRE_BFG:
            ; //DO NOT REMOVE
            ProposeFireBfgViewController *proposeFireBfgViewController = [ProposeFireBfgViewController create];
            proposeFireBfgViewController.parliament = self.parliament;
            [self.navigationController pushViewController:proposeFireBfgViewController animated:YES];
            break;
        case ROW_SEIZE_STAR:
            ; //DO NOT REMOVE
            ProposeSeizeStarViewController *proposeSeizeStarViewController = [ProposeSeizeStarViewController create];
            proposeSeizeStarViewController.parliament = self.parliament;
            [self.navigationController pushViewController:proposeSeizeStarViewController animated:YES];
            break;
        case ROW_TRANSFER_STATION_OWNERSHIP:
            ; //DO NOT REMOVE
            ProposeTransferStationOwnership *proposeTransferStationOwnership = [ProposeTransferStationOwnership create];
            proposeTransferStationOwnership.parliament = self.parliament;
            [self.navigationController pushViewController:proposeTransferStationOwnership animated:YES];
            break;
        default:
            NSLog(@"Propose what???");
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
    [super viewDidUnload];
}


- (void)dealloc {
	self.parliament = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Class Methods

+ (ChooseProposeTypeViewController *)create {
	ChooseProposeTypeViewController *chooseProposeTypeViewController = [[[ChooseProposeTypeViewController alloc] init] autorelease];
	return chooseProposeTypeViewController;
}


@end
