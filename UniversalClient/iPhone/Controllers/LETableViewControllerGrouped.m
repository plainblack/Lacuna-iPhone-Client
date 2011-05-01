//
//  LETableViewControllerGrouped.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/11/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LETableViewControllerGrouped.h"
#import "LEViewSectionTab.h"
#import "LEMacros.h"


@implementation LETableViewControllerGrouped


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

	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.separatorColor = SEPARATOR_COLOR;
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

