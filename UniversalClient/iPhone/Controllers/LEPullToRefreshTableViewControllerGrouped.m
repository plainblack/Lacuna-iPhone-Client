//
//  LEPullToRefreshTableViewControllerGrouped.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/21/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEPullToRefreshTableViewControllerGrouped.h"
#import "LEViewSectionTab.h"
#import "LEMacros.h"


@implementation LEPullToRefreshTableViewControllerGrouped


@synthesize sectionHeaders;
@synthesize pendingRequest;


#pragma mark -
#pragma mark Initialization

- (id)init {
    if ( (self = [super initWithStyle:UITableViewStyleGrouped]) ) {
		//Do any special init stuff here
		self.pendingRequest = NO;
    }
    return self;
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    self.refreshHeaderView.backgroundColor = [UIColor whiteColor];
    
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.tableView.separatorColor = SEPARATOR_COLOR;
    self.tableView.backgroundView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if ([self.sectionHeaders count] > section) {
		id object = [self.sectionHeaders objectAtIndex:section];
		
		if (object == [NSNull null]) {
			return nil;
		} else {
			return object;
		}
	} else {
		return nil;
	}
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return [LEViewSectionTab getHeight];
}


#pragma mark -
#pragma mark Table view delegate source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	/*
     Removed for now. This is not working correctly need to research this more.
     if (indexPath.row == 0) {
     cell.backgroundColor = TOP_CELL_BACKGROUND_COLOR;
     } else {
     cell.backgroundColor = CELL_BACKGROUND_COLOR;
     }
     */
}


#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
	self.sectionHeaders = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.sectionHeaders = nil;
    [super dealloc];
}


@end
