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
#import "LEBuildingUpgrade.h"
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
#import "WebPageController.h"


@interface ViewBuildingController (PrivateMethods) 

- (void)callCellSelected;

@end


@implementation ViewBuildingController


@synthesize buildingId;
@synthesize urlPart;
@synthesize selectedTableView;
@synthesize selectedIndexPath;
@synthesize watchedBuilding;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)] autorelease];

	self.sectionHeaders = [NSArray array];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	Session *session = [Session sharedInstance];
	if ([session.body.currentBuilding.id isEqualToString:self.buildingId]) {
		[session.body.currentBuilding addObserver:self forKeyPath:@"needsRefresh" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
		[session.body.currentBuilding addObserver:self forKeyPath:@"demolished" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
		self.sectionHeaders = [session.body.currentBuilding sectionHeadersForTableView:self.tableView];
		self.navigationItem.title = session.body.currentBuilding.name;
		self.watchedBuilding = session.body.currentBuilding;
		
		if (self.watchedBuilding.needsRefresh) {
			[self.tableView reloadData];
		}
	} else {
		[session.body loadBuilding:self.buildingId buildingUrl:self.urlPart];
		self.navigationItem.title = @"Loading";
	}

	[session.body addObserver:self forKeyPath:@"currentBuilding" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	Session *session = [Session sharedInstance];
	[session.body removeObserver:self forKeyPath:@"currentBuilding"];
	if (isNotNull(self.watchedBuilding)) {
		[self.watchedBuilding removeObserver:self forKeyPath:@"needsRefresh"];
		[self.watchedBuilding removeObserver:self forKeyPath:@"demolished"];
		self.watchedBuilding = nil;
	}

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
		self.selectedTableView = tableView;
		self.selectedIndexPath = indexPath;
		if ([session.body.currentBuilding isConfirmCell:indexPath]) {
			UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:[session.body.currentBuilding confirmMessage:indexPath] preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
				[self callCellSelected];
			}];
			UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
			}];
			[alert addAction:cancelAction];
			[alert addAction:okAction];
			[self presentViewController:alert animated:YES completion:nil];
			[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
			
		} else {
			[self callCellSelected];
		}
	}
}


- (void)callCellSelected {
	Session *session = [Session sharedInstance];
	UIViewController *subViewController = [session.body.currentBuilding tableView:self.selectedTableView didSelectRowAtIndexPath:self.selectedIndexPath];
	if (subViewController) {
		if ([subViewController isKindOfClass:[WebPageController class]] ) {
			[self presentViewController:subViewController animated:YES completion:nil];
		} else {
			[self.navigationController pushViewController:subViewController animated:YES];
		}
	} else {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
	self.selectedIndexPath = nil;
	self.selectedTableView = nil;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.selectedTableView = nil;
	self.selectedIndexPath = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.selectedTableView = nil;
	self.selectedIndexPath = nil;
	self.buildingId = nil;
	self.urlPart = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)refresh {
    NSLog(@"refresh called");
	Session *session = [Session sharedInstance];
	session.body.currentBuilding.needsReload = YES;
}


#pragma mark -
#pragma mark Class Methods

+ (ViewBuildingController *)create {
	return [[[ViewBuildingController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Callback


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"currentBuilding"]) {
		if (isNotNull(self.watchedBuilding)) {
			[self.watchedBuilding removeObserver:self forKeyPath:@"needsRefresh"];
			[self.watchedBuilding removeObserver:self forKeyPath:@"demolished"];
		}
		Building *newBuilding = (Building *)[change objectForKey:NSKeyValueChangeNewKey];
		if (newBuilding && ((id)newBuilding != [NSNull null])) {
			[newBuilding addObserver:self forKeyPath:@"needsRefresh" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
			[newBuilding addObserver:self forKeyPath:@"demolished" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
			self.sectionHeaders = [newBuilding sectionHeadersForTableView:self.tableView];
			self.navigationItem.title = newBuilding.name;
		}
		self.watchedBuilding = newBuilding;

		[self.tableView reloadData];
        if (isNotNull(self.watchedBuilding)) {
            [self stopLoading];
        }
	} else if ([keyPath isEqual:@"needsRefresh"]) {
		[self.tableView reloadData];
//        [self stopLoading];
	} else if ([keyPath isEqual:@"demolished"]) {
		Session *session = [Session sharedInstance];
		if (session.body.currentBuilding.demolished) {
			[self.navigationController popViewControllerAnimated:YES];
		}
	}
}

@end

