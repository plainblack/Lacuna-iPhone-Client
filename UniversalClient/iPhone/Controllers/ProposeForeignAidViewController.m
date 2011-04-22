//
//  ProposeForeignAidViewController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/14/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "ProposeForeignAidViewController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Parliament.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellNumberEntry.h"
#import "LEBuildingProposeForeignAid.h"


typedef enum {
    SECTION_TARGET,
    SECTION_ACTIONS,
    SECTION_COUNT,
} SECTION;


typedef enum {
    TARGET_ROW_TARGET,
    TARGET_ROW_AMOUNT,
    TARGET_ROW_COUNT
} TARGET_ROW;


@implementation ProposeForeignAidViewController


@synthesize selectedEmpire;
@synthesize parliament;
@synthesize amountCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Foreign Aid";
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(propose)] autorelease];
	
	self.amountCell = [LETableViewCellNumberEntry getCellForTableView:self.tableView viewController:self maxValue:[NSDecimalNumber decimalNumberWithString:@"999999999"]];
    self.amountCell.label.text = @"Amount";
    
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Tax"], [LEViewSectionTab tableView:self.tableView withText:@"Action"]);
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
                case TARGET_ROW_TARGET:
                    return [LETableViewCellButton getHeightForTableView:tableView];
                    break;
                case TARGET_ROW_AMOUNT:
                    return [LETableViewCellNumberEntry getHeightForTableView:tableView];
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
                case TARGET_ROW_TARGET:
                    ; //DO NOT REMOVE
                    LETableViewCellButton *targetCell = [LETableViewCellButton getCellForTableView:tableView];
                    if (isNotNull(self.selectedEmpire)) {
                        targetCell.textLabel.text = [self.selectedEmpire objectForKey:@"name"];
                    } else {
                        targetCell.textLabel.text = @"Pick a body to send aid to";
                    }
                    cell = targetCell;
                    break;
                case TARGET_ROW_AMOUNT:
                    cell = self.amountCell;
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
            switch (indexPath.row) {
                case TARGET_ROW_TARGET:
                    ; //DO NOT REMOVE
                    SelectEmpireController *selectEmpireController = [SelectEmpireController create];
                    selectEmpireController.delegate = self;
                    [self.navigationController pushViewController:selectEmpireController animated:YES];
                    break;
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
	self.amountCell = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.amountCell = nil;
	self.parliament = nil;
    self.selectedEmpire = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (IBAction)propose {
    [self.parliament proposeForeignAidTo:@"" amount:self.amountCell.numericValue target:self callback:@selector(proposedForeignAid:)];
}


#pragma mark - SelectEmpireControllerDelegate Methods

- (void)selectedEmpire:(NSDictionary *)empire {
    self.selectedEmpire = empire;
    NSLog(@"Selected Empire: %@", self.selectedEmpire);
    [self.navigationController popViewControllerAnimated:YES];
    [self.tableView reloadRowsAtIndexPaths:_array([NSIndexPath indexPathForRow:TARGET_ROW_TARGET inSection:SECTION_TARGET]) withRowAnimation:UITableViewRowAnimationLeft];
}


#pragma mark -
#pragma mark Callback Methods

- (void)proposedForeignAid:(LEBuildingProposeForeignAid *)request {
    if (![request wasError]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark -
#pragma mark Class Methods

+ (ProposeForeignAidViewController *)create {
	return [[[ProposeForeignAidViewController alloc] init] autorelease];
}


@end
