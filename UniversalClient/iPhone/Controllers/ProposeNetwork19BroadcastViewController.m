//
//  ProposeNetwork19BroadcastViewController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/13/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "ProposeNetwork19BroadcastViewController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Parliament.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellTextView.h"
#import "LEBuildingProposeFireBfg.h"


typedef enum {
    SECTION_MESSAGE,
    SECTION_ACTIONS,
    SECTION_COUNT,
} SECTION;


typedef enum {
    MESSAGE_ROW_MESSAGE,
    MESSAGE_ROW_COUNT
} MESSAGE_ROW;


@implementation ProposeNetwork19BroadcastViewController


@synthesize parliament;
@synthesize messageCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Fire BFG";
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(propose)] autorelease];
	
	self.messageCell = [LETableViewCellTextView getCellForTableView:self.tableView];
    
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Message"], [LEViewSectionTab tableView:self.tableView withText:@"Action"]);
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
        case SECTION_MESSAGE:
            return MESSAGE_ROW_COUNT;
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
        case SECTION_MESSAGE:
            switch (indexPath.row) {
                case MESSAGE_ROW_MESSAGE:
                    return [LETableViewCellTextView getHeightForTableView:tableView];
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
        case SECTION_MESSAGE:
            switch (indexPath.row) {
                case MESSAGE_ROW_MESSAGE:
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
	self.messageCell = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.messageCell = nil;
	self.parliament = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (IBAction)propose {
    if ([self.messageCell.textView.text length] > 0) {
        [self.parliament proposeBroadcastOnNetwork19:self.messageCell.textView.text target:self callback:@selector(proposedFireBfg:)];
    } else {
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Error" message: @"You hmust enter a message to broadcast." preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
    }
}


#pragma mark -
#pragma mark Callback Methods

- (void)proposedFireBfg:(LEBuildingProposeFireBfg *)request {
    if (![request wasError]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark -
#pragma mark Class Methods

+ (ProposeNetwork19BroadcastViewController *)create {
	return [[[ProposeNetwork19BroadcastViewController alloc] init] autorelease];
}


@end
