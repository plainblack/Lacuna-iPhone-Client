//
//  ProposeSeizeStar.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/12/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "ProposeSeizeStarViewController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Parliament.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LEBuildingProposeSeizeStar.h"


typedef enum {
    SECTION_TARGET,
    SECTION_ACTIONS,
    SECTION_COUNT,
} SECTION;


typedef enum {
    TARGET_ROW_BODY,
    TARGET_ROW_COUNT
} TARGET_ROW;


@implementation ProposeSeizeStarViewController


@synthesize parliament;
@synthesize selectedStar;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Seize Star";
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
                case TARGET_ROW_BODY:
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
                case TARGET_ROW_BODY:
                    ; //DO NOT REMOVE
                    LETableViewCellButton *targetCell = [LETableViewCellButton getCellForTableView:tableView];
                    if (self.selectedStar) {
                        targetCell.textLabel.text = [self.selectedStar objectForKey:@"name"];
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
            if (indexPath.row == TARGET_ROW_BODY) {
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
    [super dealloc];
}


#pragma mark - SelectStarInJurisdictionViewControllerDelegate Methods

- (void)selectedStarInJurisdiction:(NSDictionary *)star {
    self.selectedStar = star;
    [self.tableView reloadRowsAtIndexPaths:_array([NSIndexPath indexPathForRow:TARGET_ROW_BODY inSection:SECTION_TARGET]) withRowAnimation:UITableViewRowAnimationLeft];
}



#pragma mark -
#pragma mark Action Methods

- (IBAction)propose {
    if (isNotNull(self.selectedStar)) {
        [self.parliament proposeSeizeStar:[Util idFromDict:self.selectedStar named:@"id"] target:self callback:@selector(proposedSeizeStar:)];
    } else {
        UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"You must select a star to seize control over." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [av show];
    }
}


#pragma mark -
#pragma mark Callback Methods

- (void)proposedSeizeStar:(LEBuildingProposeSeizeStar *)request {
    if (![request wasError]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark -
#pragma mark Class Methods

+ (ProposeSeizeStarViewController *)create {
	return [[[ProposeSeizeStarViewController alloc] init] autorelease];
}


@end
