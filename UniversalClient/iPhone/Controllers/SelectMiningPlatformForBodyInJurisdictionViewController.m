//
//  SelectMiningPlatformForBodyInJurisdictionViewController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/29/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "SelectMiningPlatformForBodyInJurisdictionViewController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "Parliament.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellTextEntry.h"
#import "LEBuidingGetMiningPlatformsForAsteroidInJurisdiction.h"


@implementation SelectMiningPlatformForBodyInJurisdictionViewController


@synthesize parliament;
@synthesize body;
@synthesize miningPlatforms;
@synthesize delegate;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Select Mining Platform";
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Select one"]);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *bodyId = [Util idFromDict:self.body named:@"id"];
    [self.parliament loadMiningPlatformsForAsteroidInJurisdiction:bodyId target:self callback:@selector(bodiesLoaded:)];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MAX(1, [self.miningPlatforms count]);
}


// Customize the appearance of table view cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.miningPlatforms && [self.miningPlatforms count] > 0) {
        return [LETableViewCellButton getHeightForTableView:tableView];
    } else {
        return [LETableViewCellLabeledText getHeightForTableView:tableView];
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
    if (self.miningPlatforms) {
        if ([self.miningPlatforms count] > 0) {
            NSDictionary *miningPlatform = [self.miningPlatforms objectAtIndex:indexPath.row];
            LETableViewCellButton *miningPlatformButtonCell = [LETableViewCellButton getCellForTableView:tableView];
            miningPlatformButtonCell.textLabel.text = [NSString stringWithFormat:@"Owner: %@", [[miningPlatform objectForKey:@"empire"] objectForKey:@"name"]];
            cell = miningPlatformButtonCell;
        } else {
            LETableViewCellLabeledText *noMatchesCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
            noMatchesCell.label.text = @"Mining Platforms";
            noMatchesCell.content.text = @"None";
            cell = noMatchesCell;
        }
        
    } else {
        LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
        loadingCell.label.text = @"Mining Platforms";
        loadingCell.content.text = @"Loading";
        cell = loadingCell;
    }
	
	return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.miningPlatforms && [self.miningPlatforms count] > 0) {
        NSDictionary *miningPlatform = [self.miningPlatforms objectAtIndex:indexPath.row];
        [delegate selectedMiningPlatformForBodyInJurisdiction:miningPlatform];
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
    self.miningPlatforms = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.parliament = nil;
    self.body = nil;
    self.miningPlatforms = nil;
    [super dealloc];
}


#pragma mark - Callback Methods

- (void)bodiesLoaded:(LEBuidingGetMiningPlatformsForAsteroidInJurisdiction *)request {
    self.miningPlatforms = request.miningPlatforms;
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark Class Methods

+ (SelectMiningPlatformForBodyInJurisdictionViewController *)create {
	return [[[SelectMiningPlatformForBodyInJurisdictionViewController alloc] init] autorelease];
}


@end
