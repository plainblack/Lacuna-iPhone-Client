//
//  SelectMailboxFilterController.m
//  UniversalClient
//
//  Created by Kevin Runde on 5/1/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "SelectMailboxFilterController.h"
#import "LEMacros.h"
#import "Mailbox.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"


typedef enum {
    ROW_ALL,
    ROW_ALERT,
    ROW_ATTACK,
    ROW_COLONIZATION,
    ROW_COMPLAINT,
    ROW_CORRESPONDENCE,
    ROW_EXCAVATOR,
	ROW_FISSURE,
    ROW_INTELLIGENCE,
    ROW_MEDAL,
    ROW_MISSION,
    ROW_PARLIAMENT,
    ROW_PROBE,
    ROW_SPIES,
    ROW_TRADE,    
    ROW_TUTORIAL,
    ROW_COUNT
} ROWS;


@implementation SelectMailboxFilterController


@synthesize delegate;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Select Filter";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Mailbox Filters"]);
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
        case ROW_ALL:
            button.textLabel.text = @"All";
            break;
        case ROW_TUTORIAL:
            button.textLabel.text = @"Tutorial";
            break;
        case ROW_CORRESPONDENCE:
            button.textLabel.text = @"Correspondence";
            break;
        case ROW_MEDAL:
            button.textLabel.text = @"Medal";
            break;
        case ROW_INTELLIGENCE:
            button.textLabel.text = @"Intelligence";
            break;
        case ROW_ALERT:
            button.textLabel.text = @"Alert";
            break;
        case ROW_ATTACK:
            button.textLabel.text = @"Attack";
            break;
        case ROW_COLONIZATION:
            button.textLabel.text = @"Colonization";
            break;
        case ROW_COMPLAINT:
            button.textLabel.text = @"Complaint";
            break;
        case ROW_EXCAVATOR:
            button.textLabel.text = @"Excavator";
            break;
		case ROW_FISSURE:
			button.textLabel.text = @"Fissure";
			break;
        case ROW_MISSION:
            button.textLabel.text = @"Mission";
            break;
        case ROW_PARLIAMENT:
            button.textLabel.text = @"Parliament";
            break;
        case ROW_PROBE:
            button.textLabel.text = @"Probe";
            break;
        case ROW_SPIES:
            button.textLabel.text = @"Spies";
            break;
        case ROW_TRADE:
            button.textLabel.text = @"Trade";
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
        case ROW_ALL:
            [self.delegate selectedMailboxFilter:LEMailboxFilterTypeNone];
            break;
        case ROW_TUTORIAL:
            [self.delegate selectedMailboxFilter:LEMailboxFilterTypeTutorial];
            break;
        case ROW_CORRESPONDENCE:
            [self.delegate selectedMailboxFilter:LEMailboxFilterTypeCorrespondence];
            break;
        case ROW_MEDAL:
            [self.delegate selectedMailboxFilter:LEMailboxFilterTypeMedal];
            break;
        case ROW_INTELLIGENCE:
            [self.delegate selectedMailboxFilter:LEMailboxFilterTypeIntelligence];
            break;
        case ROW_ALERT:
            [self.delegate selectedMailboxFilter:LEMailboxFilterTypeAlert];
            break;
        case ROW_ATTACK:
            [self.delegate selectedMailboxFilter:LEMailboxFilterTypeAttack];
            break;
        case ROW_COLONIZATION:
            [self.delegate selectedMailboxFilter:LEMailboxFilterTypeColonization];
            break;
        case ROW_COMPLAINT:
            [self.delegate selectedMailboxFilter:LEMailboxFilterTypeComplaint];
            break;
        case ROW_EXCAVATOR:
            [self.delegate selectedMailboxFilter:LEMailboxFilterTypeExcavator];
            break;
		case ROW_FISSURE:
			[self.delegate selectedMailboxFilter:LEMailboxFilterTypeFissure];
			break;
        case ROW_MISSION:
            [self.delegate selectedMailboxFilter:LEMailboxFilterTypeMission];
            break;
        case ROW_PARLIAMENT:
            [self.delegate selectedMailboxFilter:LEMailboxFilterTypeParliament];
            break;
        case ROW_PROBE:
            [self.delegate selectedMailboxFilter:LEMailboxFilterTypeProbe];
            break;
        case ROW_SPIES:
            [self.delegate selectedMailboxFilter:LEMailboxFilterTypeSpies];
            break;
        case ROW_TRADE:
            [self.delegate selectedMailboxFilter:LEMailboxFilterTypeTrade];
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

+ (SelectMailboxFilterController *)create {
	SelectMailboxFilterController *selectMailboxFilterController = [[[SelectMailboxFilterController alloc] init] autorelease];
	return selectMailboxFilterController;
}


@end
