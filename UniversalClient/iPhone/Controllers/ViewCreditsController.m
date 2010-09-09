//
//  ViewCreditsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewCreditsController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "LEStatsCredits.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellText.h"
#import "LEViewSectionTab.h"


typedef	enum {
	SECTION_VERSION
} SECTION;


typedef enum {
	VERSION_ROW_IPHONE_CLIENT,
	VERSION_ROW_SERVER
} VERSION_ROW;


@implementation ViewCreditsController


@synthesize leStatsCredits;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Credits";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)] autorelease];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Version"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Credits"]);
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.leStatsCredits = [[[LEStatsCredits alloc] initWithCallback:@selector(creditsLoaded:) target:self] autorelease];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.leStatsCredits.creditGroups) {
		return 1 + [self.leStatsCredits.creditGroups count];
	} else {
		return 2;
	}

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case SECTION_VERSION:
			return 2;
			break;
		default:
			if (self.leStatsCredits.creditGroups) {
				NSInteger sectionIndex = section - 1;
				NSDictionary *creditGroup = [self.leStatsCredits.creditGroups objectAtIndex:sectionIndex];
				return [[creditGroup objectForKey:@"names"] count];
			} else {
				return 1;
			}
			break;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_VERSION:
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
			break;
		default:
			if (self.leStatsCredits.creditGroups) {
				return [LETableViewCellText getHeightForTableView:tableView];
			} else {
				return [LETableViewCellLabeledText getHeightForTableView:tableView];
			}
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	
	switch (indexPath.section) {
		case SECTION_VERSION:
			switch (indexPath.row) {
				case VERSION_ROW_IPHONE_CLIENT:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *iPhoneClientVersionCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					iPhoneClientVersionCell.label.text = @"Client";
					iPhoneClientVersionCell.content.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
					cell = iPhoneClientVersionCell;
					break;
				case VERSION_ROW_SERVER:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *serverVersionCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					serverVersionCell.label.text = @"Server";
					Session *session = [Session sharedInstance];
					if (session.serverVersion) {
						serverVersionCell.content.text = [NSString stringWithFormat:@"%@", session.serverVersion];
					} else {
						serverVersionCell.content.text = @"Loading";
					}
					cell = serverVersionCell;
					break;
				default:
					cell = nil;
					break;
			}
			break;
		default:
			if (self.leStatsCredits.creditGroups) {
				; //DO NOT REMOVE
				NSInteger sectionIndex = indexPath.section - 1;
				NSDictionary *creditGroup = [self.leStatsCredits.creditGroups objectAtIndex:sectionIndex];
				LETableViewCellText *creditCell = [LETableViewCellText getCellForTableView:tableView];
				creditCell.content.text = [[creditGroup objectForKey:@"names"] objectAtIndex:indexPath.row];
				cell = creditCell;
			} else {
				; //DO NOT REMOVE
				LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				loadingCell.label.text = @"Credits";
				loadingCell.content.text = @"Loading";
				cell = loadingCell;
			}
			break;
	}
    
    return cell;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.leStatsCredits = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.leStatsCredits = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (IBAction)logout {
	Session *session = [Session sharedInstance];
	[session logout];
}


#pragma mark -
#pragma mark Callback Methods

- (id)creditsLoaded:(LEStatsCredits *)request {
	NSMutableArray *tmp = _array([LEViewSectionTab tableView:self.tableView withText:@"Version"]);
	for (NSDictionary *creditGroup in request.creditGroups) {
		[tmp addObject:[LEViewSectionTab tableView:self.tableView withText:[creditGroup objectForKey:@"title"]]];
	}
	self.sectionHeaders = tmp;
	[self.tableView reloadData];
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (ViewCreditsController *)create {
	return [[[ViewCreditsController alloc] init] autorelease];
}


@end

