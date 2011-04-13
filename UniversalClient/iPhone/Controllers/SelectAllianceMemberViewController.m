//
//  SelectAllianceMemberViewController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/10/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "SelectAllianceMemberViewController.h"
#import "LEMacros.h"
#import "Parliament.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellTextEntry.h"
#import "LEAllianceViewProfile.h"


@implementation SelectAllianceMemberViewController


@synthesize allianceId;
@synthesize allianceMembers;
@synthesize delegate;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Select Alliance Member";
	
	self.sectionHeaders = [NSMutableArray array];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //LOAD LIST OF ALLLIANCE MEMBERS HERE
    [[[LEAllianceViewProfile alloc] initWithCallback:@selector(allianceLoaded:) target:self allianceId:self.allianceId] autorelease];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MAX(1, [self.allianceMembers count]);
}


// Customize the appearance of table view cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.allianceMembers && [self.allianceMembers count] > 0) {
        return [LETableViewCellButton getHeightForTableView:tableView];
    } else {
        return [LETableViewCellLabeledText getHeightForTableView:tableView];
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
    if (self.allianceMembers) {
        if ([self.allianceMembers count] > 0) {
            NSDictionary *allianceMember = [self.allianceMembers objectAtIndex:indexPath.row];
            LETableViewCellButton *allianceMemberButtonCell = [LETableViewCellButton getCellForTableView:tableView];
            allianceMemberButtonCell.textLabel.text = [allianceMember objectForKey:@"name"];
            cell = allianceMemberButtonCell;
        } else {
            LETableViewCellLabeledText *noMatchesCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
            noMatchesCell.content.text = @"No Alliance Members Found";
            cell = noMatchesCell;
        }
        
    } else {
        LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
        loadingCell.label.text = @"Alliance Members";
        loadingCell.content.text = @"Loading";
        cell = loadingCell;
    }
	
	return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.allianceMembers && [self.allianceMembers count] > 0) {
        NSDictionary *allianceMember = [self.allianceMembers objectAtIndex:indexPath.row];
        [delegate selectedAllianceMember:allianceMember];
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
    self.allianceId = nil;
	self.allianceMembers = nil;
    self.delegate = nil;
    [super dealloc];
}


#pragma mark - Callbacks Methods

- (void)allianceLoaded:(LEAllianceViewProfile *)request {
    self.allianceMembers = [request.profile objectForKey:@"members"];
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark Class Methods

+ (SelectAllianceMemberViewController *)create {
	return [[[SelectAllianceMemberViewController alloc] init] autorelease];
}


@end
