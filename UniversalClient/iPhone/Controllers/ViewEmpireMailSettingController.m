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
	ROW_MEDAL,
	ROW_FACEBOOK_WALL_POSTS,
	ROW_FOUND_NOTHING,
	ROW_EXCAVATOR_RESOURCES,
	ROW_EXCAVATOR_GLYPH,
	ROW_EXCAVATOR_PLAN,
	ROW_SPY_RECOVERY,
	ROW_PROBE_DETECTED,
	ROW_COUNT
} ROW;

@implementation ViewEmpireMailSettingController


@synthesize skipHappinessWarningsCell;
@synthesize skipResourceWarningsCell;
@synthesize skipPollutionWarningsCell;
@synthesize skipMedalMessagesCell;
@synthesize skipFacebookWallPostsCell;
@synthesize skipFoundNothingCell;
@synthesize skipExcavatorResourcesCell;
@synthesize skipExcavatorGlyphCell;
@synthesize skipExcavatorPlanCell;
@synthesize skipSpyRecoveryCell;
@synthesize skipProbeDetectedCell;
@synthesize empireProfile;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Mail Settings";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Mail Filters"]);
	
	self.skipHappinessWarningsCell = [LETableViewCellLabeledSwitch getCellForTableView:self.tableView];
	self.skipHappinessWarningsCell.label.text = @"Happiness Warnings";
	self.skipHappinessWarningsCell.label.font = LABEL_FONT;
	self.skipHappinessWarningsCell.isSelected = !self.empireProfile.skipHappinessWarnings;
	self.skipHappinessWarningsCell.delegate = self;
	
	self.skipResourceWarningsCell = [LETableViewCellLabeledSwitch getCellForTableView:self.tableView];
	self.skipResourceWarningsCell.label.text = @"Resource Warnings";
	self.skipResourceWarningsCell.label.font = LABEL_FONT;
	self.skipResourceWarningsCell.isSelected = !self.empireProfile.skipResourceWarnings;
	self.skipResourceWarningsCell.delegate = self;
	
	self.skipPollutionWarningsCell = [LETableViewCellLabeledSwitch getCellForTableView:self.tableView];
	self.skipPollutionWarningsCell.label.text = @"Pollution Warnings";
	self.skipPollutionWarningsCell.label.font = LABEL_FONT;
	self.skipPollutionWarningsCell.isSelected = !self.empireProfile.skipPollutionWarnings;
	self.skipPollutionWarningsCell.delegate = self;
	
	self.skipMedalMessagesCell = [LETableViewCellLabeledSwitch getCellForTableView:self.tableView];
	self.skipMedalMessagesCell.label.text = @"Medal Messages";
	self.skipMedalMessagesCell.label.font = LABEL_FONT;
	self.skipMedalMessagesCell.isSelected = !self.empireProfile.skipMedalMessages;
	self.skipMedalMessagesCell.delegate = self;
	
	self.skipFacebookWallPostsCell = [LETableViewCellLabeledSwitch getCellForTableView:self.tableView];
	self.skipFacebookWallPostsCell.label.text = @"Facebook Wall Posts";
	self.skipFacebookWallPostsCell.label.font = LABEL_FONT;
	self.skipFacebookWallPostsCell.isSelected = !self.empireProfile.skipFacebookWallPosts;
	self.skipFacebookWallPostsCell.delegate = self;
	
	self.skipFoundNothingCell = [LETableViewCellLabeledSwitch getCellForTableView:self.tableView];
	self.skipFoundNothingCell.label.text = @"Found Nothing";
	self.skipFoundNothingCell.label.font = LABEL_FONT;
	self.skipFoundNothingCell.isSelected = !self.empireProfile.skipFoundNothing;
	self.skipFoundNothingCell.delegate = self;
	
	self.skipExcavatorResourcesCell = [LETableViewCellLabeledSwitch getCellForTableView:self.tableView];
	self.skipExcavatorResourcesCell.label.text = @"Excavator Resources";
	self.skipExcavatorResourcesCell.label.font = LABEL_FONT;
	self.skipExcavatorResourcesCell.isSelected = !self.empireProfile.skipExcavatorResources;
	self.skipExcavatorResourcesCell.delegate = self;
	
	self.skipExcavatorGlyphCell = [LETableViewCellLabeledSwitch getCellForTableView:self.tableView];
	self.skipExcavatorGlyphCell.label.text = @"Excavator Glyphs";
	self.skipExcavatorGlyphCell.label.font = LABEL_FONT;
	self.skipExcavatorGlyphCell.isSelected = !self.empireProfile.skipExcavatorGlyph;
	self.skipExcavatorGlyphCell.delegate = self;
	
	self.skipExcavatorPlanCell = [LETableViewCellLabeledSwitch getCellForTableView:self.tableView];
	self.skipExcavatorPlanCell.label.text = @"Excavator Plan";
	self.skipExcavatorPlanCell.label.font = LABEL_FONT;
	self.skipExcavatorPlanCell.isSelected = !self.empireProfile.skipExcavatorPlan;
	self.skipExcavatorPlanCell.delegate = self;
	
	self.skipSpyRecoveryCell = [LETableViewCellLabeledSwitch getCellForTableView:self.tableView];
	self.skipSpyRecoveryCell.label.text = @"Spy Recovery";
	self.skipSpyRecoveryCell.label.font = LABEL_FONT;
	self.skipSpyRecoveryCell.isSelected = !self.empireProfile.skipSpyRecovery;
	self.skipSpyRecoveryCell.delegate = self;
	
	self.skipProbeDetectedCell = [LETableViewCellLabeledSwitch getCellForTableView:self.tableView];
	self.skipProbeDetectedCell.label.text = @"Probe Detected";
	self.skipProbeDetectedCell.label.font = LABEL_FONT;
	self.skipProbeDetectedCell.isSelected = !self.empireProfile.skipProbeDetected;
	self.skipProbeDetectedCell.delegate = self;
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
	return ROW_COUNT;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [LETableViewCellLabeledSwitch getHeightForTableView:tableView];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
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
		case ROW_FACEBOOK_WALL_POSTS:
			cell = self.skipFacebookWallPostsCell;
			break;
		case ROW_FOUND_NOTHING:
			cell = self.skipFoundNothingCell;
			break;
		case ROW_EXCAVATOR_RESOURCES:
			cell = self.skipExcavatorResourcesCell;
			break;
		case ROW_EXCAVATOR_GLYPH:
			cell = self.skipExcavatorGlyphCell;
			break;
		case ROW_EXCAVATOR_PLAN:
			cell = self.skipExcavatorPlanCell;
			break;
		case ROW_SPY_RECOVERY:
			cell = self.skipSpyRecoveryCell;
			break;
		case ROW_PROBE_DETECTED:
			cell = self.skipProbeDetectedCell;
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
	self.skipFacebookWallPostsCell = nil;
	self.skipFoundNothingCell = nil;
	self.skipExcavatorResourcesCell = nil;
	self.skipExcavatorGlyphCell = nil;
	self.skipExcavatorPlanCell = nil;
	self.skipSpyRecoveryCell = nil;
	self.skipProbeDetectedCell = nil;
	self.empireProfile = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark LETableViewCellLabeledSwitchDelegate Methods

- (void)cell:(LETableViewCellLabeledSwitch *)cell switchedTo:(BOOL)isOn {
	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	NSString *filterName = nil;

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
		case ROW_FACEBOOK_WALL_POSTS:
			filterName = @"skip_facebook_wall_posts";
			break;
		case ROW_FOUND_NOTHING:
			filterName = @"skip_found_nothing";
			break;
		case ROW_EXCAVATOR_RESOURCES:
			filterName = @"skip_excavator_resources";
			break;
		case ROW_EXCAVATOR_GLYPH:
			filterName = @"skip_excavator_glyph";
			break;
		case ROW_EXCAVATOR_PLAN:
			filterName = @"skip_excavator_plan";
			break;
		case ROW_SPY_RECOVERY:
			filterName = @"skip_spy_recovery";
			break;
		case ROW_PROBE_DETECTED:
			filterName = @"skip_probe_detected";
			break;
		default:
			break;
	}

	NSString *text = nil;
	if (isOn) {
		text = @"0";
	} else {
		text = @"1";
	}

	[[[LEEmpireEditProfile alloc] initWithCallback:@selector(filtersUpdated:) target:self textKey:filterName text:text] autorelease];
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

