//
//  ViewDuckQuackController.m
//  UniversalClient
//
//  Created by Kevin Runde on 11/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewDuckQuackController.h"
#import "LEMacros.h"
#import "Session.h"
#import "Entertainment.h"
#import "LEBuildingQuackDuck.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellParagraph.h"


@implementation ViewDuckQuackController


@synthesize entertainment;
@synthesize quackMessage;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Duck Quack";
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Duck Quack"]);
	self.quackMessage = @"Quacking Duck ...";
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.entertainment quackDuck:self callback:@selector(duckQuacked:)];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [LETableViewCellParagraph getHeightForTableView:tableView text:self.quackMessage];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	LETableViewCellParagraph *quackCell = [LETableViewCellParagraph getCellForTableView:tableView];
	quackCell.content.font = [UIFont fontWithName:@"Courier-Bold" size:14.0];
	quackCell.content.text = self.quackMessage;
	
    return quackCell;
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
	self.entertainment = nil;
	self.quackMessage = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callback Methods

- (void)duckQuacked:(LEBuildingQuackDuck *)request {
	self.quackMessage = request.message;
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewDuckQuackController *)create {
	return [[[ViewDuckQuackController alloc] init] autorelease];
}


@end

