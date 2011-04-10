//
//  SelectStarInJurisdictionViewController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/10/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "SelectStarInJurisdictionViewController.h"
#import "LEMacros.h"
#import "Session.h"
#import "Parliament.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellTextEntry.h"
#import "LEMapSearchStars.h"


@implementation SelectStarInJurisdictionViewController


@synthesize parliament;
@synthesize delegate;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Select Star";
	
	self.sectionHeaders = [NSMutableArray array];
    self->watchingStarsInJurisdiction = NO;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self->watchingStarsInJurisdiction = YES;
    [self.parliament addObserver:self forKeyPath:@"starsInJurisdiction" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    [self.parliament loadStarsInJurisdiction];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self->watchingStarsInJurisdiction) {
        [self.parliament removeObserver:self forKeyPath:@"starsInJurisdiction"];
        self->watchingStarsInJurisdiction = NO;
    }
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MAX(1, [self.parliament.starsInJurisdiction count]);
}


// Customize the appearance of table view cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.parliament.starsInJurisdiction && [self.parliament.starsInJurisdiction count] > 0) {
        return [LETableViewCellButton getHeightForTableView:tableView];
    } else {
        return [LETableViewCellLabeledText getHeightForTableView:tableView];
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
    if (self.parliament.starsInJurisdiction) {
        if ([self.parliament.starsInJurisdiction count] > 0) {
            NSDictionary *star = [self.parliament.starsInJurisdiction objectAtIndex:indexPath.row];
            LETableViewCellButton *starButtonCell = [LETableViewCellButton getCellForTableView:tableView];
            starButtonCell.textLabel.text = [star objectForKey:@"name"];
            cell = starButtonCell;
        } else {
            LETableViewCellLabeledText *noMatchesCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
            noMatchesCell.content.text = @"No Stars In Jurisdiction";
            cell = noMatchesCell;
        }
        
    } else {
        LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
        loadingCell.label.text = @"Stars";
        loadingCell.content.text = @"Loading";
        cell = loadingCell;
    }
	
	return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.parliament.starsInJurisdiction && [self.parliament.starsInJurisdiction count] > 0) {
        NSDictionary *star = [self.parliament.starsInJurisdiction objectAtIndex:indexPath.row];
        [delegate selectedStarInJurisdiction:star];
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
    [super dealloc];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"starsInJurisdiction"]) {
		[self.tableView reloadData];
    }
}


#pragma mark -
#pragma mark Class Methods

+ (SelectStarInJurisdictionViewController *)create {
	return [[[SelectStarInJurisdictionViewController alloc] init] autorelease];
}


@end
