//
//  ProposeTransferStationOwnership.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/10/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "ProposeTransferStationOwnership.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "Parliament.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LEBuildingProposeTransferStationOwnership.h"


typedef enum {
    SECTION_TRANSFER_TO,
    SECTION_ACTIONS,
    SECTION_COUNT,
} SECTION;


typedef enum {
    TRANSFER_TO_ROW_EMPIRE,
    TRANSFER_TO_ROW_COUNT
} TARGET_ROW;


@implementation ProposeTransferStationOwnership


@synthesize parliament;
@synthesize selectedEmpire;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Transfer Station Ownership";
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(propose)] autorelease];
    
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Transfer To"], [LEViewSectionTab tableView:self.tableView withText:@"Action"]);
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
        case SECTION_TRANSFER_TO:
            return TRANSFER_TO_ROW_COUNT;
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
        case SECTION_TRANSFER_TO:
            switch (indexPath.row) {
                case TRANSFER_TO_ROW_EMPIRE:
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
        case SECTION_TRANSFER_TO:
            switch (indexPath.row) {
                case TRANSFER_TO_ROW_EMPIRE:
                    ; //DO NOT REMOVE
                    LETableViewCellButton *targetCell = [LETableViewCellButton getCellForTableView:tableView];
                    if (self.selectedEmpire) {
                        targetCell.textLabel.text = [self.selectedEmpire objectForKey:@"name"];
                    } else {
                        targetCell.textLabel.text = @"Pick Alliance Member";
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
        case SECTION_TRANSFER_TO:
            if (indexPath.row == TRANSFER_TO_ROW_EMPIRE) {
                Session *session = [Session sharedInstance];
                SelectAllianceMemberViewController *selectAllianceMemberViewController = [SelectAllianceMemberViewController create];
                selectAllianceMemberViewController.allianceId = session.body.allianceId;
                selectAllianceMemberViewController.delegate = self;
                [self.navigationController pushViewController:selectAllianceMemberViewController animated:YES];
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
    self.selectedEmpire = nil;
    [super dealloc];
}


#pragma mark - SelectAllianceMemberViewControllerDelegate

- (void)selectedAllianceMember:(NSDictionary *)empire {
    self.selectedEmpire = empire;
    [self.navigationController popViewControllerAnimated:YES];
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark Action Methods

- (IBAction)propose {
    if (isNotNull(self.selectedEmpire)) {
        [self.parliament proposeTransferStationOwnershipTo:[Util idFromDict:self.selectedEmpire named:@"id"] target:self callback:@selector(proposedTransferStationOwnership:)];
    } else {
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Error" message: @"You must select an alliance member to transfer station ownership to." preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
    }
}


#pragma mark -
#pragma mark Callback Methods

- (void)proposedTransferStationOwnership:(LEBuildingProposeTransferStationOwnership *)request {
    if (![request wasError]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark -
#pragma mark Class Methods

+ (ProposeTransferStationOwnership *)create {
	return [[[ProposeTransferStationOwnership alloc] init] autorelease];
}


@end
