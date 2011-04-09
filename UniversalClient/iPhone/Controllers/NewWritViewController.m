//
//  NewWritViewController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/9/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "NewWritViewController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "Parliament.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellTextEntry.h"
#import "LETableViewCellLabeledTextView.h"
#import "LEBuildingProposeWrit.h"


typedef enum {
    SECTION_WRIT,
    SECTION_ACTIONS,
} SECTIONS;

typedef enum {
    WRIT_ROW_TITLE,
    WRIT_ROW_DESCRIPTION,
} WRIT_ROW;

@implementation NewWritViewController


@synthesize parliament;
@synthesize nameCell;
@synthesize messageCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"New Writ";
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(propose)] autorelease];
	
	self.nameCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.nameCell.label.text = @"Title";
	
	
	self.messageCell = [LETableViewCellLabeledTextView getCellForTableView:self.tableView];
	self.messageCell.label.text = @"Description";
	
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"To"], [LEViewSectionTab tableView:self.tableView withText:@"Message"]);
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SECTION_WRIT:
            return 2;
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
        case SECTION_WRIT:
            switch (indexPath.row) {
                case WRIT_ROW_TITLE:
                    return [LETableViewCellTextEntry getHeightForTableView:tableView];
                    break;
                case WRIT_ROW_DESCRIPTION:
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
        case SECTION_WRIT:
            switch (indexPath.row) {
                case WRIT_ROW_TITLE:
                    cell = self.nameCell;
                    break;
                case WRIT_ROW_DESCRIPTION:
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
    self.nameCell = nil;
	self.messageCell = nil;
    [super viewDidUnload];
}


- (void)dealloc {
    self.nameCell = nil;
	self.messageCell = nil;
	self.parliament = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (IBAction)propose {
    [self.parliament proposeWritTitle:self.nameCell.textField.text description:self.messageCell.textView.text target:self callback:@selector(proposedWrit:)];
}


#pragma mark -
#pragma mark SelectEmpireControllerDelegate Methods

- (void)proposedWrit:(LEBuildingProposeWrit *)request {
    if (![request wasError]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark -
#pragma mark Class Methods

+ (NewWritViewController *)create {
	return [[[NewWritViewController alloc] init] autorelease];
}


@end
