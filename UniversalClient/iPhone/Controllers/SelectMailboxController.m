//
//  SelectMailboxController.m
//  UniversalClient
//
//  Created by Kevin Runde on 5/1/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "SelectMailboxController.h"
#import "LEMacros.h"
#import "Mailbox.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"


typedef enum {
    ROW_INBOX,
    ROW_ARCHIVED,
    ROW_TRASHED,
    ROW_SENT,
    ROW_COUNT
} ROWS;


@implementation SelectMailboxController


@synthesize delegate;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Select Mailbox";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Mailboxes"]);
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
        case ROW_INBOX:
            button.textLabel.text = @"Inbox";
            break;
        case ROW_ARCHIVED:
            button.textLabel.text = @"Archived";
            break;
        case ROW_TRASHED:
            button.textLabel.text = @"Trashed";
            break;
        case ROW_SENT:
            button.textLabel.text = @"Sent";
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
        case ROW_INBOX:
            [self.delegate selectedMailbox:LEMailboxTypeInbox];
            break;
        case ROW_ARCHIVED:
            [self.delegate selectedMailbox:LEMailboxTypeArchived];
            break;
        case ROW_TRASHED:
            [self.delegate selectedMailbox:LEMailboxTypeTrash];
            break;
        case ROW_SENT:
            [self.delegate selectedMailbox:LEMailboxTypeSent];
            break;
        default:
            NSLog(@"Invalid Mailbox");
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
	self.delegate = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Class Methods

+ (SelectMailboxController *)create {
	SelectMailboxController *selectMailboxController = [[[SelectMailboxController alloc] init] autorelease];
	return selectMailboxController;
}


@end
