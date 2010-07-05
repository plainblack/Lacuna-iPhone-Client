//
//  ViewBuildingController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewBuildingController.h"
#import "LEMacros.h"
#import "Util.h"
#import "LEViewSectionTab.h"
#import "LEBuildingView.h"
#import "LEUpgradeBuilding.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellBuildingStats.h"
#import "LETableViewCellCost.h"
#import "LETableViewCellUnbuildable.h"
#import "ViewNetwork19NewsController.h"
#import "LEBuildingRestrictCoverage.h"
#import "LETableViewCellLabeledText.h"
#import "LEBuildingTrainSpy.h"
#import "ViewSpiesController.h"
#import "RecycleController.h"
#import "LEBuildingSubsidizeRecycling.h"
#import "LEBuildingDemolish.h"
#import "LEBuildingThrowParty.h"
#import "LEBuildingSubsidizeBuildQueue.h"
#import "Session.h"


@implementation ViewBuildingController


@synthesize buildingId;
@synthesize urlPart;
@synthesize buildingsByLoc;
@synthesize buttonsByLoc;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	Session *session = [Session sharedInstance];
	[session.body addObserver:self forKeyPath:@"currentBuilding" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	[session.body loadBuilding:self.buildingId buildingUrl:self.urlPart];

	self.navigationItem.title = @"Loading";
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	Session *session = [Session sharedInstance];
	if (session.body.currentBuilding) {
		[session.body clearBuilding];
	}
	[session.body removeObserver:self forKeyPath:@"currentBuilding"];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	Session *session = [Session sharedInstance];
	if (session.body.currentBuilding) {
		return [session.body.currentBuilding sectionCount];
	} else {
		return 0;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	Session *session = [Session sharedInstance];
	if (session.body.currentBuilding) {
		return [session.body.currentBuilding numRowsInSection:section];
	} else {
		return 0;
	}

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	Session *session = [Session sharedInstance];
	if (session.body.currentBuilding) {
		return [session.body.currentBuilding tableView:tableView heightForRowAtIndexPath:indexPath];
	} else {
		return tableView.rowHeight;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	Session *session = [Session sharedInstance];
	if (session.body.currentBuilding) {
		return [session.body.currentBuilding tableView:tableView cellForRowAtIndexPath:indexPath];
	} else {
		return nil;
	}
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Session *session = [Session sharedInstance];
	if (session.body.currentBuilding) {
		UIViewController *subViewController = [session.body.currentBuilding tableView:tableView didSelectRowAtIndexPath:indexPath];
		if (subViewController) {
			[self.navigationController pushViewController:subViewController animated:YES];
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
	[super viewDidUnload];
}


- (void)dealloc {
	self.buildingId = nil;
	self.urlPart = nil;
	self.buttonsByLoc = nil;
	self.buildingsByLoc = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewBuildingController *)create {
	return [[[ViewBuildingController alloc] init] autorelease];
}


#pragma mark --
#pragma mark KVO Callback

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"currentBuilding"]) {
		Building *newBuilding = (Building *)[change objectForKey:NSKeyValueChangeNewKey];
		if (newBuilding && ((id)newBuilding != [NSNull null])) {
			[newBuilding addObserver:self forKeyPath:@"needsRefresh" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
			[newBuilding addObserver:self forKeyPath:@"pendingBuild" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
			[newBuilding addObserver:self forKeyPath:@"demolished" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
			self.sectionHeaders = [newBuilding sectionHeadersForTableView:self.tableView];
			self.navigationItem.title = newBuilding.name;
		}
		Building *oldBuilding = (Building *)[change objectForKey:NSKeyValueChangeOldKey];
		if (oldBuilding && ((id)oldBuilding != [NSNull null])) {
			[oldBuilding removeObserver:self forKeyPath:@"needsRefresh"];
			[oldBuilding removeObserver:self forKeyPath:@"pendingBuild"];
			[oldBuilding removeObserver:self forKeyPath:@"demolished"];
		}
		[self.tableView reloadData];
	} else if ([keyPath isEqual:@"needsRefresh"]) {
		[self.tableView reloadData];
	} else if ([keyPath isEqual:@"pendingBuild"]) {
		[self.tableView reloadData];
	} else if ([keyPath isEqual:@"demolished"]) {
		Session *session = [Session sharedInstance];
		if (session.body.currentBuilding.demolished) {
			[self.navigationController popViewControllerAnimated:YES];
		}
	}
}


@end

