//
//  SelectBodyForStarInJurisdictionViewController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/25/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "SelectBodyForStarInJurisdictionViewController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "Parliament.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellTextEntry.h"
#import "LEBuildingGetBodiesForStarInJurisdiction.h"


@implementation SelectBodyForStarInJurisdictionViewController


@synthesize parliament;
@synthesize star;
@synthesize bodies;
@synthesize delegate;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Select Body";
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Select one"]);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *starId = [Util idFromDict:self.star named:@"id"];
    [self.parliament loadBodiesForStarInJurisdiction:starId target:self callback:@selector(bodiesLoaded:)];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MAX(1, [self.bodies count]);
}


// Customize the appearance of table view cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.bodies && [self.bodies count] > 0) {
        return [LETableViewCellButton getHeightForTableView:tableView];
    } else {
        return [LETableViewCellLabeledText getHeightForTableView:tableView];
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
    if (self.bodies) {
        if ([self.bodies count] > 0) {
            NSDictionary *body = [self.bodies objectAtIndex:indexPath.row];
            LETableViewCellButton *bodyButtonCell = [LETableViewCellButton getCellForTableView:tableView];
            bodyButtonCell.textLabel.text = [body objectForKey:@"name"];
            cell = bodyButtonCell;
        } else {
            LETableViewCellLabeledText *noMatchesCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
            noMatchesCell.label.text = @"Bodies";
            noMatchesCell.content.text = @"None";
            cell = noMatchesCell;
        }
        
    } else {
        LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
        loadingCell.label.text = @"Bodies";
        loadingCell.content.text = @"Loading";
        cell = loadingCell;
    }
	
	return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.bodies && [self.bodies count] > 0) {
        NSDictionary *body = [self.bodies objectAtIndex:indexPath.row];
        [delegate selectedBodyForStarInJurisdiction:body];
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
    self.bodies = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.parliament = nil;
    self.star = nil;
    self.bodies = nil;
    [super dealloc];
}


#pragma mark - Callback Methods

- (void)bodiesLoaded:(LEBuildingGetBodiesForStarInJurisdiction *)request {
    self.bodies = request.bodies;
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark Class Methods

+ (SelectBodyForStarInJurisdictionViewController *)create {
	return [[[SelectBodyForStarInJurisdictionViewController alloc] init] autorelease];
}


@end
