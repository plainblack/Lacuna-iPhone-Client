//
//  ProposeInductMemberViewController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/13/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "ProposeInductMemberViewController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "Parliament.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledTextView.h"
#import "LEBuildingCreateAlliance.h"
#import "LEBuildingProposeInductMember.h"


typedef enum {
    SECTION_INDUCT,
    SECTION_ACTIONS,
    SECTION_COUNT,
} SECTION;


typedef enum {
    INDUCT_ROW_EMPIRE,
    INDUCT_ROW_MESSAGE,
    INDUCT_ROW_COUNT
} INDUCT_ROW;


@implementation ProposeInductMemberViewController


@synthesize parliament;
@synthesize selectedEmpire;
@synthesize messageCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Induct Member";
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(propose)] autorelease];
	
	self.messageCell = [LETableViewCellLabeledTextView getCellForTableView:self.tableView];
	self.messageCell.label.text = @"Message";
	
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Induct"], [LEViewSectionTab tableView:self.tableView withText:@"Actions"]);
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return SECTION_COUNT;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SECTION_INDUCT:
            return INDUCT_ROW_COUNT;
            break;
        case SECTION_ACTIONS:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}


// Customize the appearance of table view cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_INDUCT:
            switch (indexPath.row) {
                case INDUCT_ROW_EMPIRE:
                    return [LETableViewCellButton getHeightForTableView:tableView];
                    break;
                case INDUCT_ROW_MESSAGE:
                    return [LETableViewCellLabeledTextView getHeightForTableView:tableView];
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
		case SECTION_INDUCT:
            switch (indexPath.row) {
                case INDUCT_ROW_EMPIRE:
                    ; //DO NOT REMOVE
                    LETableViewCellButton *targetCell = [LETableViewCellButton getCellForTableView:tableView];
                    if (self.selectedEmpire) {
                        targetCell.textLabel.text = [self.selectedEmpire objectForKey:@"name"];
                    } else {
                        targetCell.textLabel.text = @"Pick New Member";
                    }
                    cell = targetCell;
                    break;
                case INDUCT_ROW_MESSAGE:
                    cell = self.messageCell;
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
		case SECTION_INDUCT:
            switch (indexPath.row) {
                case INDUCT_ROW_EMPIRE:
                    ; //DO NOT REMOVE
                    SelectEmpireController *selectEmpireController = [SelectEmpireController create];
                    selectEmpireController.delegate = self;
                    [self.navigationController pushViewController:selectEmpireController animated:YES];
                    break;
            }
            break;
		case SECTION_ACTIONS:
            switch (indexPath.row) {
                case 0:
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
	self.messageCell = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.messageCell = nil;
	self.parliament = nil;
    self.selectedEmpire = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (IBAction)propose {
    if ( isNotNull(self.selectedEmpire) && ([self.messageCell.textView.text length]>0) ) {
        [self.parliament proposeInductMember:[Util idFromDict:self.selectedEmpire named:@"id"] message:self.messageCell.textView.text target:self callback:@selector(proposedInductMember:)];
    } else {
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Error" message: @"You must select an empire to induct and enter a message." preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
    }
}


#pragma mark -
#pragma mark Callback Methods

- (void)proposedInductMember:(LEBuildingProposeInductMember *)request {
    if (![request wasError]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark -
#pragma mark SelectEmpireControllerDelegate Methods

- (void)selectedEmpire:(NSDictionary *)empire {
	self.selectedEmpire = empire;
	[self.navigationController popViewControllerAnimated:YES];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Class Methods

+ (ProposeInductMemberViewController *)create {
	return [[[ProposeInductMemberViewController alloc] init] autorelease];
}


@end
