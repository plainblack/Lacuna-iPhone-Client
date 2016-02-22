//
//  ViewMissionsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 11/6/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewMissionsController.h"
#import "LEMacros.h"
#import "Util.h"
#import	"MissionCommand.h"
#import "Mission.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLongLabeledText.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellLabeledParagraph.h"
#import "LETableViewCellParagraph.h"
#import "LEBuildingCompleteMission.h"
#import "LEBuildingSkipMission.h"


typedef enum {
	ROW_MISSION_NAME,
	ROW_MAX_UNIVERSITY_LEVEL,
	ROW_DATE_POSTED,
	ROW_MISSION_DESCRIPTION,
	ROW_OBJECTIVES,
	ROW_REWARDS,
	ROW_ACCEPT_BUTTON,
	ROW_SKIP_BUTTON,
} ROW;


@implementation ViewMissionsController


@synthesize missionCommand;
@synthesize skipMission;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Missions";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.missionCommand addObserver:self forKeyPath:@"missions" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self.missionCommand loadMissions];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.missionCommand removeObserver:self forKeyPath:@"missions"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.missionCommand && self.missionCommand.missions) {
		if ([self.missionCommand.missions count] > 0) {
			return [self.missionCommand.missions count];
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.missionCommand && self.missionCommand.missions) {
		if ([self.missionCommand.missions count] > 0) {
			return 8;
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.missionCommand && self.missionCommand.missions) {
		if ([self.missionCommand.missions count] > 0) {
			Mission *mission = [self.missionCommand.missions objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_MISSION_NAME:
				case ROW_DATE_POSTED:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_MAX_UNIVERSITY_LEVEL:
					return [LETableViewCellLongLabeledText getHeightForTableView:tableView];
					break;
				case ROW_MISSION_DESCRIPTION:
					return [LETableViewCellParagraph getHeightForTableView:tableView text:mission.missionDescription];
					break;
				case ROW_OBJECTIVES:
					return [LETableViewCellLabeledParagraph getHeightForTableView:tableView text:mission.objectivesAsText];
					break;
				case ROW_REWARDS:
					return [LETableViewCellLabeledParagraph getHeightForTableView:tableView text:mission.rewardsAsText];
					break;
				case ROW_ACCEPT_BUTTON:
				case ROW_SKIP_BUTTON:
					return [LETableViewCellButton getHeightForTableView:tableView];
					break;
				default:
					return tableView.rowHeight;
					break;
			}
		} else {
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
		}

	} else {
		return [LETableViewCellLabeledText getHeightForTableView:tableView];
	}
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
	if (self.missionCommand && self.missionCommand.missions) {
		if ([self.missionCommand.missions count] > 0) {
			Mission *mission = [self.missionCommand.missions objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_MISSION_NAME:
					; // DO NOT REMOVE
					LETableViewCellLabeledText *missionNameCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					missionNameCell.label.text = @"Name";
					missionNameCell.content.text = mission.name;
					cell = missionNameCell;
					break;
				case ROW_MAX_UNIVERSITY_LEVEL:
					; // DO NOT REMOVE
					LETableViewCellLongLabeledText *maxUniversityLevelCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
					maxUniversityLevelCell.label.text = @"Max University Level";
					maxUniversityLevelCell.content.text = [Util prettyNSDecimalNumber:mission.maxUniversityLevel];
					cell = maxUniversityLevelCell;
					break;
				case ROW_DATE_POSTED:
					; // DO NOT REMOVE
					LETableViewCellLabeledText *missionPostedCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					missionPostedCell.label.text = @"Posted";
					missionPostedCell.content.text = [Util formatDate:mission.datePosted];
					cell = missionPostedCell;
					break;
				case ROW_MISSION_DESCRIPTION:
					; // DO NOT REMOVE
					LETableViewCellParagraph *missionDescriptionCell = [LETableViewCellParagraph getCellForTableView:tableView];
					missionDescriptionCell.content.text = mission.missionDescription;
					cell = missionDescriptionCell;
					break;
				case ROW_OBJECTIVES:
					; // DO NOT REMOVE
					LETableViewCellLabeledParagraph *missionObjectivesCell = [LETableViewCellLabeledParagraph getCellForTableView:tableView];
					missionObjectivesCell.label.text = @"Objectives";
					missionObjectivesCell.content.text = mission.objectivesAsText;
					cell = missionObjectivesCell;
					break;
				case ROW_REWARDS:
					; // DO NOT REMOVE
					LETableViewCellLabeledParagraph *missionRewardsCell = [LETableViewCellLabeledParagraph getCellForTableView:tableView];
					missionRewardsCell.label.text = @"Rewards";
					missionRewardsCell.content.text = mission.rewardsAsText;
					cell = missionRewardsCell;
					break;
				case ROW_ACCEPT_BUTTON:
					; // DO NOT REMOVE
					LETableViewCellButton *acceptButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					acceptButtonCell.textLabel.text = @"Accept Mission";
					cell = acceptButtonCell;
					break;
				case ROW_SKIP_BUTTON:
					; // DO NOT REMOVE
					LETableViewCellButton *skipButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					skipButtonCell.textLabel.text = @"Skip Mission";
					cell = skipButtonCell;
					break;
				default:
					cell = nil;
					break;
			}
		} else {
			LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			loadingCell.label.text = @"Missions";
			loadingCell.content.text = @"None";
			cell = loadingCell;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Missions";
		loadingCell.content.text = @"Loading";
		cell = loadingCell;
	}
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self->pendingRequest) {
        return nil;
    } else {
        return indexPath;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self->pendingRequest) {
        if (self.missionCommand && self.missionCommand.missions) {
            if ([self.missionCommand.missions count] > 0) {
                Mission *mission = [self.missionCommand.missions objectAtIndex:indexPath.section];
                switch (indexPath.row) {
                    case ROW_ACCEPT_BUTTON:
                        self->pendingRequest = YES;
                        [self.missionCommand completeMission:mission target:self callback:@selector(missionCompleted:)];
                        break;
                    case ROW_SKIP_BUTTON:
                        self.skipMission = mission;						
						UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you really sure you want to skip this mission?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
						UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
							self->pendingRequest = YES;
							[self.missionCommand skipMission:self.skipMission target:self callback:@selector(missionSkipped:)];
						}];
						UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
							[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
						}];
						[alert addAction:cancelAction];
						[alert addAction:okAction];
						[self presentViewController:alert animated:YES completion:nil];
                        break;
                }
            }
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
    [super viewDidUnload];
}


- (void)dealloc {
	self.missionCommand = nil;
	self.skipMission = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callback Methods

- (void)missionCompleted:(LEBuildingCompleteMission *)request {
	if (![request wasError]) {
		[self.tableView reloadData];
	} else {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
    self->pendingRequest = NO;
}


- (void)missionSkipped:(LEBuildingSkipMission *)request {
	if (![request wasError]) {
		[self.tableView reloadData];
	} else {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
    self->pendingRequest = NO;
}


#pragma mark -
#pragma mark Class Methods

+ (ViewMissionsController *)create {
	return [[[ViewMissionsController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"missions"]) {
		[self.tableView reloadData];
	}
}


@end
