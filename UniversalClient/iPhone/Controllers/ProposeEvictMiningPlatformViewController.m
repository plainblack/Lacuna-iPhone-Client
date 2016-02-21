//
//  ProposeEvictMiningPlatformViewController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/13/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "ProposeEvictMiningPlatformViewController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Parliament.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LEBuildingProposeEvictMiningPlatform.h"


typedef enum {
    SECTION_TARGET,
    SECTION_ACTIONS,
    SECTION_COUNT,
} SECTION;


typedef enum {
    TARGET_ROW_MINING_PLATFORM,
    TARGET_ROW_COUNT
} TARGET_ROW;


@implementation ProposeEvictMiningPlatformViewController


@synthesize parliament;
@synthesize selectedStar;
@synthesize selectedAsteroid;
@synthesize selectedMiningPlatform;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Evict Mining Platform";
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(propose)] autorelease];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Target"], [LEViewSectionTab tableView:self.tableView withText:@"Action"]);
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SECTION_COUNT;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SECTION_TARGET:
            return TARGET_ROW_COUNT;
            break;
        case SECTION_ACTIONS:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SECTION_TARGET:
            switch (indexPath.row) {
                case TARGET_ROW_MINING_PLATFORM:
                    return [LETableViewCellButton getHeightForTableView:tableView];
                    break;
                default:
                    return 0.0;
                    break;
            }
            break;
        case SECTION_ACTIONS:
            return [LETableViewCellButton getHeightForTableView:tableView];
            break;
        default:
			return 0.0;
            break;
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case SECTION_TARGET:
            switch (indexPath.row) {
                case TARGET_ROW_MINING_PLATFORM:
                    ; //DO NOT REMOVE
                    LETableViewCellButton *targetCell = [LETableViewCellButton getCellForTableView:tableView];
                    if (self.selectedMiningPlatform) {
                        targetCell.textLabel.text = [NSString stringWithFormat:@"Owner: %@", [[self.selectedMiningPlatform objectForKey:@"empire"] objectForKey:@"name"]];
                    } else {
                        targetCell.textLabel.text = @"Pick target";
                    }
                    cell = targetCell;
                    break;
            }
            break;
        case SECTION_ACTIONS:
            ; //DO NOT REMOVE
            LETableViewCellButton *proposeCell = [LETableViewCellButton getCellForTableView:tableView];
            proposeCell.textLabel.text = @"Propose";
            cell = proposeCell;
            break;
    }
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SECTION_TARGET:
            if (indexPath.row == TARGET_ROW_MINING_PLATFORM) {
                SelectStarInJurisdictionViewController *selectStarInJurisdictionViewController = [SelectStarInJurisdictionViewController create];
                selectStarInJurisdictionViewController.parliament = self.parliament;
                selectStarInJurisdictionViewController.delegate = self;
                [self.navigationController pushViewController:selectStarInJurisdictionViewController animated:YES];
            }
            break;
        case SECTION_ACTIONS:
            if (indexPath.row == 0) {
                [self propose];
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
    [super viewDidUnload];
}


- (void)dealloc {
	self.parliament = nil;
    self.selectedStar = nil;
    self.selectedAsteroid = nil;
    self.selectedMiningPlatform = nil;
    [super dealloc];
}


#pragma mark - SelectStarInJurisdictionViewControllerDelegate Methods

- (void)selectedStarInJurisdiction:(NSDictionary *)star {
    self.selectedStar = star;
    SelectBodyForStarInJurisdictionViewController *vc = [SelectBodyForStarInJurisdictionViewController create];
    vc.parliament = self.parliament;
    vc.star = self.selectedStar;
    vc.delegate = self;
    vc.asteroidsOnly = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - SelectBodyForStarInJurisdictionViewControllerDelegate Methods

- (void)selectedBodyForStarInJurisdiction:(NSDictionary *)body {
    self.selectedAsteroid = body;
    SelectMiningPlatformForBodyInJurisdictionViewController *vc = [SelectMiningPlatformForBodyInJurisdictionViewController create];
    vc.parliament = self.parliament;
    vc.body = self.selectedAsteroid;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - SelectMiningPlatformForBodyInJurisdictionViewControllerDelegate Methods

- (void)selectedMiningPlatformForBodyInJurisdiction:(NSDictionary *)miningPlatform {
    self.selectedMiningPlatform = miningPlatform;
    [self.navigationController popToViewController:self animated:YES];
    [self.tableView reloadRowsAtIndexPaths:_array([NSIndexPath indexPathForRow:TARGET_ROW_MINING_PLATFORM inSection:SECTION_TARGET]) withRowAnimation:UITableViewRowAnimationLeft];
}


#pragma mark -
#pragma mark Action Methods

- (IBAction)propose {
    if (isNotNull(self.selectedMiningPlatform)) {
        [self.parliament proposeEvictMiningPlatform:[Util idFromDict:self.selectedMiningPlatform named:@"id"] target:self callback:@selector(proposedMiningPlatform:)];
    } else {
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Error" message: @"You must select a mining platform to evict." preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
    }
}


#pragma mark -
#pragma mark Callback Methods

- (void)proposedMiningPlatform:(LEBuildingProposeEvictMiningPlatform *)request {
    if (![request wasError]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark -
#pragma mark Class Methods

+ (ProposeEvictMiningPlatformViewController *)create {
	return [[[ProposeEvictMiningPlatformViewController alloc] init] autorelease];
}


@end
