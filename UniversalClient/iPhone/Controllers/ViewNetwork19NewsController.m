//
//  ViewNetwork19NewsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewNetwork19NewsController.h"
#import "LEMacros.h";
#import "LEViewSectionTab.h"
#import "LETableViewCellNewsItem.h"
#import "LETableViewCellLabeledText.h"
#import "LEBuildingViewNews.h"


@implementation ViewNetwork19NewsController


@synthesize buildingId;
@synthesize urlPart;
@synthesize newsItems;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Network 19 News";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView createWithText:@"News"]);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	//Get data and start reload task
	[[[LEBuildingViewNews alloc] initWithCallback:@selector(newsLoaded:) target:self buildingId:self.buildingId buildingUrl:self.urlPart] autorelease];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	//Get data and start reload task
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger count = [self.newsItems count];
	if (count > 0) {
		return count;
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger count = [self.newsItems count];
	if (count > 0) {
		NSDictionary *newsItem = [self.newsItems objectAtIndex:indexPath.row];
		return [LETableViewCellNewsItem getHeightForTableView:tableView text:[newsItem objectForKey:@"headline"]];
	} else {
		return [LETableViewCellLabeledText getHeightForTableView:tableView];
	}

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger count = [self.newsItems count];
	if (count > 0) {
		NSDictionary *newsItem = [self.newsItems objectAtIndex:indexPath.row];
		
		LETableViewCellNewsItem *newsItemCell = [LETableViewCellNewsItem getCellForTableView:tableView];
		[newsItemCell displayNewsItem:newsItem];
		return newsItemCell;
	} else {
		if (self.newsItems) {
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			emptyCell.label.text = @"";
			emptyCell.content.text = @"Empty";
			return emptyCell;
		} else {
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			loadingCell.label.text = @"";
			loadingCell.content.text = @"Loading";
			return loadingCell;
		}
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
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	self.newsItems = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	self.buildingId = nil;
	self.urlPart = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callback Methods
- (id)newsLoaded:(LEBuildingViewNews *)request {
	self.newsItems = request.newsItems;
	[self.tableView reloadData];
	
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (ViewNetwork19NewsController *)create {
	return [[[ViewNetwork19NewsController alloc] init] autorelease];
}


@end

