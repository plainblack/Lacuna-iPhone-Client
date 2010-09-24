//
//  ViewEmpireMailSettingController.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/23/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewEmpireMailSettingController.h"
#import "LEMacros.h"
#import "Util.h"
#import "LEViewSectionTab.h"
#import "EmpireProfile.h"
#import "LEEmpireEditProfile.h"

typedef enum {
	ROW_HAPPINESS,
	ROW_RESOURCE,
	ROW_POLLUTION,
	ROW_MEDAL
} ROW;

@implementation ViewEmpireMailSettingController


@synthesize skipHappinessWarningsCell;
@synthesize skipResourceWarningsCell;
@synthesize skipPollutionWarningsCell;
@synthesize skipMedalMessagesCell;
@synthesize empireProfile;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Mail Settings";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Mail Filters"]);
	
	self.skipHappinessWarningsCell = [LETableViewCellLabeledSwitch getCellForTableView:self.tableView];
	self.skipHappinessWarningsCell.label.text = @"Skip Happiness Warnings";
	self.skipHappinessWarningsCell.label.font = LABEL_FONT;
	self.skipHappinessWarningsCell.isSelected = self.empireProfile.skipHappinessWarnings;
	self.skipHappinessWarningsCell.delegate = self;
	
	self.skipResourceWarningsCell = [LETableViewCellLabeledSwitch getCellForTableView:self.tableView];
	self.skipResourceWarningsCell.label.text = @"Skip Resource Warnings";
	self.skipResourceWarningsCell.label.font = LABEL_FONT;
	self.skipResourceWarningsCell.isSelected = self.empireProfile.skipResourceWarnings;
	self.skipResourceWarningsCell.delegate = self;
	
	self.skipPollutionWarningsCell = [LETableViewCellLabeledSwitch getCellForTableView:self.tableView];
	self.skipPollutionWarningsCell.label.text = @"Skip Pollution Warnings";
	self.skipPollutionWarningsCell.label.font = LABEL_FONT;
	self.skipPollutionWarningsCell.isSelected = self.empireProfile.skipPollutionWarnings;
	self.skipPollutionWarningsCell.delegate = self;
	
	self.skipMedalMessagesCell = [LETableViewCellLabeledSwitch getCellForTableView:self.tableView];
	self.skipMedalMessagesCell.label.text = @"Skip Medal Messages";
	self.skipMedalMessagesCell.label.font = LABEL_FONT;
	self.skipMedalMessagesCell.isSelected = self.empireProfile.skipMedalMessages;
	self.skipMedalMessagesCell.delegate = self;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 4;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [LETableViewCellLabeledSwitch getHeightForTableView:tableView];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	
	switch (indexPath.row) {
		case ROW_HAPPINESS:
			cell = self.skipHappinessWarningsCell;
			break;
		case ROW_RESOURCE:
			cell = self.skipResourceWarningsCell;
			break;
		case ROW_POLLUTION:
			cell = self.skipPollutionWarningsCell;
			break;
		case ROW_MEDAL:
			cell = self.skipMedalMessagesCell;
			break;
		default:
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
    [super viewDidUnload];
}


- (void)dealloc {
	self.skipHappinessWarningsCell = nil;
	self.skipResourceWarningsCell = nil;
	self.skipPollutionWarningsCell = nil;
	self.skipMedalMessagesCell = nil;
	self.empireProfile = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark LETableViewCellLabeledSwitchDelegate Methods

- (void)cell:(LETableViewCellLabeledSwitch *)cell switchedTo:(BOOL)isOn {
	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	NSString *filterName;

	switch (indexPath.row) {
		case ROW_HAPPINESS:
			filterName = @"skip_happiness_warnings";
			break;
		case ROW_RESOURCE:
			filterName = @"skip_resource_warnings";
			break;
		case ROW_POLLUTION:
			filterName = @"skip_pollution_warnings";
			break;
		case ROW_MEDAL:
			filterName = @"skip_medal_messages";
			break;
		default:
			break;
	}

	[[LEEmpireEditProfile alloc] initWithCallback:@selector(filtersUpdated:) target:self textKey:filterName text:(isOn ? @"1" : @"0")];
}


#pragma mark -
#pragma mark Callback Methods

- (id)filtersUpdated:(LEEmpireEditProfile *)request {
	return nil;
}

#pragma mark -
#pragma mark Class Methods

+ (ViewEmpireMailSettingController *)create {
	return [[[ViewEmpireMailSettingController alloc] init] autorelease];
}


@end

