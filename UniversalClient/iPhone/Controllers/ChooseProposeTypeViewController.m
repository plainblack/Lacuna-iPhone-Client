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
#import "ProposeRenameStarViewController.h"
#import "ProposeNetwork19BroadcastViewController.h"
#import "ProposeInductMemberViewController.h"
#import "ProposeExpelMemberViewController.h"
#import "ProposeRenameBodyViewController.h"
#import "LEBuildingProposeMembersOnlyMiningRights.h"
#import "LEBuildingProposeMembersOnlyColonization.h"
#import "ProposeEvictMiningPlatformViewController.h"
#import "ProposeTaxationViewController.h"
#import "ProposeForeignAidViewController.h"


typedef enum {
    ROW_WRIT,
    ROW_EVICT_MINING_PLATFORM,
    ROW_EXPEL_MEMBER,
    ROW_FIRE_BFG,
    ROW_FOREIGN_AID,
    ROW_INDUCT_MEMBER,
    ROW_MEMBERS_ONLY_COLONIZATION_RIGHTS,
    ROW_MEMBERS_ONLY_MINING_RIGHTS,
    ROW_NETWORK19_BROADCAST,
    ROW_RENAME_BODY,
    ROW_RENAME_STAR,
    ROW_SEIZE_STAR,
    ROW_TAXATION,
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
        case ROW_EVICT_MINING_PLATFORM:
            button.textLabel.text = @"Evict Mining Platform";
            break;
        case ROW_EXPEL_MEMBER:
            button.textLabel.text = @"Expel Member";
            break;
        case ROW_FIRE_BFG:
            button.textLabel.text = @"Fire BFG";
            break;
        case ROW_FOREIGN_AID:
            button.textLabel.text = @"Foreign Aid";
            break;
        case ROW_INDUCT_MEMBER:
            button.textLabel.text = @"Induct Member";
            break;
        case ROW_MEMBERS_ONLY_COLONIZATION_RIGHTS:
            button.textLabel.text = @"Members Only Colonization Rights";
            break;
        case ROW_MEMBERS_ONLY_MINING_RIGHTS:
            button.textLabel.text = @"Members Only Mining Rights";
            break;
        case ROW_NETWORK19_BROADCAST:
            button.textLabel.text = @"Network19 Broadcast";
            break;
        case ROW_RENAME_BODY:
            button.textLabel.text = @"Rename Body";
            break;
        case ROW_RENAME_STAR:
            button.textLabel.text = @"Rename Star";
            break;
        case ROW_SEIZE_STAR:
            button.textLabel.text = @"Seize Star";
            break;
        case ROW_TAXATION:
            button.textLabel.text = @"Taxation";
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
        case ROW_EVICT_MINING_PLATFORM:
            ; //DO NOT REMOVE
            ProposeEvictMiningPlatformViewController *proposeEvictMiningPlatformViewController = [ProposeEvictMiningPlatformViewController create];
            proposeEvictMiningPlatformViewController.parliament = self.parliament;
            [self.navigationController pushViewController:proposeEvictMiningPlatformViewController animated:YES];
            break;
        case ROW_EXPEL_MEMBER:
            ; //DO NOT REMOVE
            ProposeExpelMemberViewController *proposeExpelMemberViewController = [ProposeExpelMemberViewController create];
            proposeExpelMemberViewController.parliament = self.parliament;
            [self.navigationController pushViewController:proposeExpelMemberViewController animated:YES];
            break;
        case ROW_FIRE_BFG:
            ; //DO NOT REMOVE
            ProposeFireBfgViewController *proposeFireBfgViewController = [ProposeFireBfgViewController create];
            proposeFireBfgViewController.parliament = self.parliament;
            [self.navigationController pushViewController:proposeFireBfgViewController animated:YES];
            break;
        case ROW_FOREIGN_AID:
            ; //DO NOT REMOVE
            ProposeForeignAidViewController *proposeForeignAidViewController = [ProposeForeignAidViewController create];
            proposeForeignAidViewController.parliament = self.parliament;
            [self.navigationController pushViewController:proposeForeignAidViewController animated:YES];
            break;
        case ROW_INDUCT_MEMBER:
            ; //DO NOT REMOVE
            ProposeInductMemberViewController *proposeInductMemberViewController = [ProposeInductMemberViewController create];
            proposeInductMemberViewController.parliament = self.parliament;
            [self.navigationController pushViewController:proposeInductMemberViewController animated:YES];
            break;
        case ROW_MEMBERS_ONLY_COLONIZATION_RIGHTS:
            [self.parliament proposeMembersOnlyColonizationTarget:self callback:@selector(proposedMembersOnlyColonization:)];
            break;
        case ROW_MEMBERS_ONLY_MINING_RIGHTS:
            [self.parliament proposeMembersOnlyMiningRightsTarget:self callback:@selector(proposedMembersOnlyMiningRights:)];
            break;
        case ROW_NETWORK19_BROADCAST:
            ; //DO NOT REMOVE
            ProposeNetwork19BroadcastViewController *proposeNetwork19BroadcastViewController = [ProposeNetwork19BroadcastViewController create];
            proposeNetwork19BroadcastViewController.parliament = self.parliament;
            [self.navigationController pushViewController:proposeNetwork19BroadcastViewController animated:YES];
            break;
        case ROW_RENAME_BODY:
            ; //DO NOT REMOVE
            ProposeRenameBodyViewController *proposeRenameBodyViewController = [ProposeRenameBodyViewController create];
            proposeRenameBodyViewController.parliament = self.parliament;
            [self.navigationController pushViewController:proposeRenameBodyViewController animated:YES];
            break;
        case ROW_RENAME_STAR:
            ; //DO NOT REMOVE
            ProposeRenameStarViewController *proposeRenameStarViewController = [ProposeRenameStarViewController create];
            proposeRenameStarViewController.parliament = self.parliament;
            [self.navigationController pushViewController:proposeRenameStarViewController animated:YES];
            break;
        case ROW_SEIZE_STAR:
            ; //DO NOT REMOVE
            ProposeSeizeStarViewController *proposeSeizeStarViewController = [ProposeSeizeStarViewController create];
            proposeSeizeStarViewController.parliament = self.parliament;
            [self.navigationController pushViewController:proposeSeizeStarViewController animated:YES];
            break;
        case ROW_TAXATION:
            ; //DO NOT REMOVE
            ProposeTaxationViewController *proposeTaxationViewController = [ProposeTaxationViewController create];
            proposeTaxationViewController.parliament = self.parliament;
            [self.navigationController pushViewController:proposeTaxationViewController animated:YES];
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


#pragma mark - Callback Methods

- (void)proposedMembersOnlyColonization:(LEBuildingProposeMembersOnlyColonization *)request {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
	UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Proposed" message: @"Members only colonization rights has been proposed." preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
						 { [av dismissViewControllerAnimated:YES completion:nil]; }];
	[av addAction: ok];
	[self presentViewController:av animated:YES completion:nil];
}


- (void)proposedMembersOnlyMiningRights:(LEBuildingProposeMembersOnlyMiningRights *)request {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
	UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Proposed" message: @"Members only mining rights has been proposed." preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
						 { [av dismissViewControllerAnimated:YES completion:nil]; }];
	[av addAction: ok];
	[self presentViewController:av animated:YES completion:nil];
}


#pragma mark -
#pragma mark Class Methods

+ (ChooseProposeTypeViewController *)create {
	ChooseProposeTypeViewController *chooseProposeTypeViewController = [[[ChooseProposeTypeViewController alloc] init] autorelease];
	return chooseProposeTypeViewController;
}


@end
