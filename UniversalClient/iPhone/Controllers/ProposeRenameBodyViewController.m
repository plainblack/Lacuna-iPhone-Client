//
//  ProposeRenameUninhabitedViewController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/13/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "ProposeRenameBodyViewController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Parliament.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LEBuildingProposeRenameAsteroid.h"
#import "LEBuildingProposeRenameUninhabited.h"


typedef enum {
    SECTION_TARGET,
    SECTION_ACTIONS,
    SECTION_COUNT,
} SECTION;


typedef enum {
    TARGET_ROW_UNINHABITED,
    TARGET_ROW_NAME,
    TARGET_ROW_COUNT
} TARGET_ROW;


@implementation ProposeRenameBodyViewController


@synthesize parliament;
@synthesize selectedStar;
@synthesize selectedBody;
@synthesize nameCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Rename Body";
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(propose)] autorelease];
	
	self.nameCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.nameCell.delegate = self;
	self.nameCell.label.text = @"New Name";
	self.nameCell.textField.text = @"";
    
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Uninhabited Planet"], [LEViewSectionTab tableView:self.tableView withText:@"Action"]);
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
                case TARGET_ROW_UNINHABITED:
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
                case TARGET_ROW_UNINHABITED:
                    ; //DO NOT REMOVE
                    LETableViewCellButton *targetCell = [LETableViewCellButton getCellForTableView:tableView];
                    if (self.selectedBody) {
                        targetCell.textLabel.text = [self.selectedBody objectForKey:@"name"];
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
            if (indexPath.row == TARGET_ROW_UNINHABITED) {
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
    self.selectedBody = nil;
    [super dealloc];
}


#pragma mark - SelectStarInJurisdictionViewControllerDelegate Methods

- (void)selectedStarInJurisdiction:(NSDictionary *)star {
    self.selectedStar = star;
    SelectBodyForStarInJurisdictionViewController *vc = [SelectBodyForStarInJurisdictionViewController create];
    vc.parliament = self.parliament;
    vc.star = self.selectedStar;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - SelectBodyForStarInJurisdictionViewControllerDelegate Methods

- (void)selectedBodyForStarInJurisdiction:(NSDictionary *)body {
    self.selectedBody = body;
    [self.navigationController popToViewController:self animated:YES];
    [self.tableView reloadRowsAtIndexPaths:_array([NSIndexPath indexPathForRow:TARGET_ROW_UNINHABITED inSection:SECTION_TARGET]) withRowAnimation:UITableViewRowAnimationLeft];
}


#pragma mark -
#pragma mark Action Methods

- (IBAction)propose {
    if (isNotNull(self.selectedBody)) {
        if ([[self.selectedBody objectForKey:@"type"] isEqualToString:@"asteroid"]) {
            [self.parliament proposeRenameAsteroid:[Util idFromDict:self.selectedBody named:@"id"] name:self.nameCell.textField.text target:self callback:@selector(proposedRenameAsteroid:)];
        } else {
            if (isNotNull([self.selectedBody objectForKey:@"empire"])) {
				UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Error" message: @"You cannot rename a planet that is already controlled." preferredStyle:UIAlertControllerStyleAlert];
				UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
									 { [av dismissViewControllerAnimated:YES completion:nil]; }];
				[av addAction: ok];
				[self presentViewController:av animated:YES completion:nil];
            } else {
                [self.parliament proposeRenameUninhabited:[Util idFromDict:self.selectedBody named:@"id"] name:self.nameCell.textField.text target:self callback:@selector(proposedRenameUninhabited:)];
            }
        }
    } else {
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Error" message: @"You must select an astroid to rename." preferredStyle:UIAlertControllerStyleAlert];
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

- (void)proposedRenameAsteroid:(LEBuildingProposeRenameAsteroid *)request {
    if (![request wasError]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)proposedRenameUninhabited:(LEBuildingProposeRenameUninhabited *)request {
    if (![request wasError]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark -
#pragma mark Class Methods

+ (ProposeRenameBodyViewController *)create {
	return [[[ProposeRenameBodyViewController alloc] init] autorelease];
}


@end
