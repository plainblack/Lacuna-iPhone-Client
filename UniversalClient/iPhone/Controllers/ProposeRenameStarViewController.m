//
//  ProposeRenameStarViewController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/12/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "ProposeRenameStarViewController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Parliament.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LEBuildingProposeRenameStar.h"


typedef enum {
    SECTION_TARGET,
    SECTION_ACTIONS,
    SECTION_COUNT,
} SECTION;


typedef enum {
    TARGET_ROW_STAR,
    TARGET_ROW_NAME,
    TARGET_ROW_COUNT
} TARGET_ROW;


@implementation ProposeRenameStarViewController


@synthesize parliament;
@synthesize selectedStar;
@synthesize nameCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Rename Star";
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(propose)] autorelease];
	
	self.nameCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.nameCell.delegate = self;
	self.nameCell.label.text = @"New Name";
	self.nameCell.textField.text = @"";

	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Star"], [LEViewSectionTab tableView:self.tableView withText:@"Action"]);
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
                case TARGET_ROW_STAR:
                    return [LETableViewCellButton getHeightForTableView:tableView];
                    break;
                case TARGET_ROW_NAME:
                    return [LETableViewCellTextEntry getHeightForTableView:tableView];
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
                case TARGET_ROW_STAR:
                    ; //DO NOT REMOVE
                    LETableViewCellButton *targetCell = [LETableViewCellButton getCellForTableView:tableView];
                    if (self.selectedStar) {
                        targetCell.textLabel.text = [self.selectedStar objectForKey:@"name"];
                    } else {
                        targetCell.textLabel.text = @"Pick target";
                    }
                    cell = targetCell;
                    break;
                case TARGET_ROW_NAME:
                    cell = self.nameCell;
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
            if (indexPath.row == TARGET_ROW_STAR) {
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
    [self.navigationController popViewControllerAnimated:YES];
    [self.tableView reloadRowsAtIndexPaths:_array([NSIndexPath indexPathForRow:TARGET_ROW_STAR inSection:SECTION_TARGET]) withRowAnimation:UITableViewRowAnimationLeft];
}



#pragma mark -
#pragma mark Action Methods

- (IBAction)propose {
    if (isNotNull(self.selectedStar)) {
        [self.parliament proposeRenameStar:[Util idFromDict:self.selectedStar named:@"id"] name:self.nameCell.textField.text target:self callback:@selector(proposedRenameStar:)];
    } else {
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Error" message: @"You must select a star to rename." preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
    }
}


#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.nameCell.textField) {
		[self.nameCell resignFirstResponder];
	}
	
	return YES;
}


#pragma mark -
#pragma mark Callback Methods

- (void)proposedRenameStar:(LEBuildingProposeRenameStar *)request {
    if (![request wasError]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark -
#pragma mark Class Methods

+ (ProposeRenameStarViewController *)create {
	return [[[ProposeRenameStarViewController alloc] init] autorelease];
}


@end
