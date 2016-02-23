//
//  ViewStatsControllerV2.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewStatsControllerV2.h"
#import "LEMacros.h"
#import "Session.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import	"ViewEmpireRankingsController.h"
#import "ViewColonyRankingsController.h"
#import	"ViewSpyRankingsController.h"
#import "ViewWeeklyMedalWinnersController.h"
#import "ViewAllianceRankingsController.h"
//#import "ViewEmpireIDsController.h"


typedef enum {
	SECTION_WEEKLY_MEDAL_WINNERS,
	SECTION_ALLIANCE_RANKINGS,
	SECTION_EMPIRE_RANKINGS,
	SECTION_COLONY_RANKINS,
	SECTION_SPY_RANKINGS,
} SECTION;


typedef enum {
	EMPIRE_ROW_EMPIRE_SIZE,
	EMPIRE_ROW_OFFENSIVE_SUCCESS,
	EMPIRE_ROW_DEFENSIVE_SUCCESS,
	EMPIRE_ROW_DIRTIEST,
//    EMPIRE_ROW_IDS
} EMPIRE_ROW;


typedef enum {
	COLONY_ROW_POPULATION,
} COLONY_ROW;


typedef enum {
	SPY_ROW_LEVEL,
	SPY_ROW_SUCCESS_RATE,
	SPY_ROW_DIRTIEST,
} SPY_ROW;


typedef enum {
	ALLIANCE_ROW_AVERAGE_EMPIRE_SIZE,
	ALLIANCE_ROW_OFFENSIVE_SUCCESS,
	ALLIANCE_ROW_DEFENSIVE_SUCCESS,
	ALLIANCE_ROW_DIRTIEST,
} ALLIANCE_ROW;


@implementation ViewStatsControllerV2


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	if ([self.navigationController.viewControllers objectAtIndex:0] == self) {
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)] autorelease];
	}
	self.navigationItem.title = @"Stats";
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Weekly Medals"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Alliance Rankings"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Empire Rankings"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Colony Rankings"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Spy Rankings"]);
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
	return 5;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case SECTION_EMPIRE_RANKINGS:
			return 4;
			break;
		case SECTION_COLONY_RANKINS:
			return 1;
			break;
		case SECTION_SPY_RANKINGS:
			return 3;
			break;
		case SECTION_WEEKLY_MEDAL_WINNERS:
			return 1;
			break;
		case SECTION_ALLIANCE_RANKINGS:
			return 4;
			break;
		default:
			return 0;
			break;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_EMPIRE_RANKINGS:
			switch (indexPath.row) {
				case EMPIRE_ROW_EMPIRE_SIZE:
				case EMPIRE_ROW_OFFENSIVE_SUCCESS:
				case EMPIRE_ROW_DEFENSIVE_SUCCESS:
				case EMPIRE_ROW_DIRTIEST:
//                case EMPIRE_ROW_IDS:
					return [LETableViewCellButton getHeightForTableView:tableView];
					break;
				default:
					return 0.0;
					break;
			}
			break;
		case SECTION_COLONY_RANKINS:
			switch (indexPath.row) {
				case COLONY_ROW_POPULATION:
					return [LETableViewCellButton getHeightForTableView:tableView];
					break;
				default:
					return 0.0;
					break;
			}
			break;
		case SECTION_SPY_RANKINGS:
			switch (indexPath.row) {
				case SPY_ROW_LEVEL:
				case SPY_ROW_SUCCESS_RATE:
				case SPY_ROW_DIRTIEST:
					return [LETableViewCellButton getHeightForTableView:tableView];
					break;
				default:
					return 0.0;
					break;
			}
			break;
		case SECTION_WEEKLY_MEDAL_WINNERS:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case SECTION_ALLIANCE_RANKINGS:
			switch (indexPath.row) {
				case ALLIANCE_ROW_AVERAGE_EMPIRE_SIZE:
				case ALLIANCE_ROW_OFFENSIVE_SUCCESS:
				case ALLIANCE_ROW_DEFENSIVE_SUCCESS:
				case ALLIANCE_ROW_DIRTIEST:
					return [LETableViewCellButton getHeightForTableView:tableView];
					break;
				default:
					return 0.0;
					break;
			}
			break;
		default:
			return 0.0;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
	
	switch (indexPath.section) {
		case SECTION_EMPIRE_RANKINGS:
			switch (indexPath.row) {
				case EMPIRE_ROW_EMPIRE_SIZE:
					; //DO NOT REMOVE
					LETableViewCellButton *empireSizeButton = [LETableViewCellButton getCellForTableView:tableView];
					empireSizeButton.textLabel.text = @"Largest Empires";
					cell = empireSizeButton;
					break;
				case EMPIRE_ROW_OFFENSIVE_SUCCESS:
					; //DO NOT REMOVE
					LETableViewCellButton *offensiveSuccessEmpiresButton = [LETableViewCellButton getCellForTableView:tableView];
					offensiveSuccessEmpiresButton.textLabel.text = @"Most Offensive Empires";
					cell = offensiveSuccessEmpiresButton;
					break;
				case EMPIRE_ROW_DEFENSIVE_SUCCESS:
					; //DO NOT REMOVE
					LETableViewCellButton *defensiveSuccessEmpiresButton = [LETableViewCellButton getCellForTableView:tableView];
					defensiveSuccessEmpiresButton.textLabel.text = @"Most Defensive Empires";
					cell = defensiveSuccessEmpiresButton;
					break;
				case EMPIRE_ROW_DIRTIEST:
					; //DO NOT REMOVE
					LETableViewCellButton *diretiesEmpiresButton = [LETableViewCellButton getCellForTableView:tableView];
					diretiesEmpiresButton.textLabel.text = @"Dirtiest Empires";
					cell = diretiesEmpiresButton;
					break;

/*                case EMPIRE_ROW_IDS:
					; //DO NOT REMOVE
					LETableViewCellButton *empireIDsButton = [LETableViewCellButton getCellForTableView:tableView];
					empireIDsButton.textLabel.text = @"Empire IDs";
					cell = empireIDsButton;
					break;
*/				default:
					cell = nil;
					break;
			}
			break;
		case SECTION_COLONY_RANKINS:
			switch (indexPath.row) {
				case COLONY_ROW_POPULATION:
					; //DO NOT REMOVE
					LETableViewCellButton *colonyPopulationButton = [LETableViewCellButton getCellForTableView:tableView];
					colonyPopulationButton.textLabel.text = @"Largest Colonies";
					cell = colonyPopulationButton;
					break;
				default:
					cell = nil;
					break;
			}
			break;
		case SECTION_SPY_RANKINGS:
			switch (indexPath.row) {
				case SPY_ROW_LEVEL:
					; //DO NOT REMOVE
					LETableViewCellButton *spyLevelButton = [LETableViewCellButton getCellForTableView:tableView];
					spyLevelButton.textLabel.text = @"Highest Level Spies";
					cell = spyLevelButton;
					break;
				case SPY_ROW_SUCCESS_RATE:
					; //DO NOT REMOVE
					LETableViewCellButton *spySuccessRateButton = [LETableViewCellButton getCellForTableView:tableView];
					spySuccessRateButton.textLabel.text = @"Most Successful Spies";
					cell = spySuccessRateButton;
					break;
				case SPY_ROW_DIRTIEST:
					; //DO NOT REMOVE
					LETableViewCellButton *dirtiestSpiesButton = [LETableViewCellButton getCellForTableView:tableView];
					dirtiestSpiesButton.textLabel.text = @"Dirties Spies";
					cell = dirtiestSpiesButton;
					break;
				default:
					cell = nil;
					break;
			}
			break;
		case SECTION_WEEKLY_MEDAL_WINNERS:
			; //DO NOT REMOVE
			LETableViewCellButton *weeklyMedalWinnersButton = [LETableViewCellButton getCellForTableView:tableView];
			weeklyMedalWinnersButton.textLabel.text = @"Weekly Medal Winners";
			cell = weeklyMedalWinnersButton;
			break;
		case SECTION_ALLIANCE_RANKINGS:
			switch (indexPath.row) {
				case ALLIANCE_ROW_AVERAGE_EMPIRE_SIZE:
					; //DO NOT REMOVE
					LETableViewCellButton *empireSizeButton = [LETableViewCellButton getCellForTableView:tableView];
					empireSizeButton.textLabel.text = @"Largest Alliances";
					cell = empireSizeButton;
					break;
				case ALLIANCE_ROW_OFFENSIVE_SUCCESS:
					; //DO NOT REMOVE
					LETableViewCellButton *offensiveSuccessEmpiresButton = [LETableViewCellButton getCellForTableView:tableView];
					offensiveSuccessEmpiresButton.textLabel.text = @"Most Offensive Alliances";
					cell = offensiveSuccessEmpiresButton;
					break;
				case ALLIANCE_ROW_DEFENSIVE_SUCCESS:
					; //DO NOT REMOVE
					LETableViewCellButton *defensiveSuccessEmpiresButton = [LETableViewCellButton getCellForTableView:tableView];
					defensiveSuccessEmpiresButton.textLabel.text = @"Most Defensive Alliances";
					cell = defensiveSuccessEmpiresButton;
					break;
				case ALLIANCE_ROW_DIRTIEST:
					; //DO NOT REMOVE
					LETableViewCellButton *diretiesEmpiresButton = [LETableViewCellButton getCellForTableView:tableView];
					diretiesEmpiresButton.textLabel.text = @"Dirtiest Alliances";
					cell = diretiesEmpiresButton;
					break;
				default:
					cell = nil;
					break;
			}
			break;
		default:
			cell = nil;
			break;
	}
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_EMPIRE_RANKINGS:
			; //DO NOT REMOVE
			ViewEmpireRankingsController *viewEmpireRankingsController = [ViewEmpireRankingsController create];
			switch (indexPath.row) {
				case EMPIRE_ROW_EMPIRE_SIZE:
					viewEmpireRankingsController.sortBy = @"empire_size_rank";
					break;
				case EMPIRE_ROW_OFFENSIVE_SUCCESS:
					viewEmpireRankingsController.sortBy = @"offense_success_rate_rank";
					break;
				case EMPIRE_ROW_DEFENSIVE_SUCCESS:
					viewEmpireRankingsController.sortBy = @"defense_success_rate_rank";
					break;
				case EMPIRE_ROW_DIRTIEST:
					viewEmpireRankingsController.sortBy = @"dirtiest_rank";
					break;
            }
/*                ViewEmpireIDsController *viewEmpireIDsController = [ViewEmpireIDsController create];
                    switch (indexPath.row) {
                case EMPIRE_ROW_IDS:
					viewEmpireIDsController.sortBy = @"empire_id";
					break;
			}*/
			[self.navigationController pushViewController:viewEmpireRankingsController animated:YES];
			break;
		case SECTION_COLONY_RANKINS:
			; //DO NOT REMOVE
			ViewColonyRankingsController *viewColonyRankingsController = [ViewColonyRankingsController create];
			switch (indexPath.row) {
				case COLONY_ROW_POPULATION:
					viewColonyRankingsController.sortBy = @"population_rank";
					break;
			}
			[self.navigationController pushViewController:viewColonyRankingsController animated:YES];
			break;
		case SECTION_SPY_RANKINGS:
			; //DO NOT REMOVE
			ViewSpyRankingsController *viewSpyRankingsController = [ViewSpyRankingsController create];
			switch (indexPath.row) {
				case SPY_ROW_LEVEL:
					viewSpyRankingsController.sortBy = @"level_rank";
					break;
				case SPY_ROW_SUCCESS_RATE:
					viewSpyRankingsController.sortBy = @"success_rate_rank";
					break;
				case SPY_ROW_DIRTIEST:
					viewSpyRankingsController.sortBy = @"success_rate_rank";
					break;
			}
			[self.navigationController pushViewController:viewSpyRankingsController animated:YES];
			break;
		case SECTION_WEEKLY_MEDAL_WINNERS:
			; //DO NOT REMOVE
			ViewWeeklyMedalWinnersController *viewWeeklyMedalWinnersController = [ViewWeeklyMedalWinnersController create];
			[self.navigationController pushViewController:viewWeeklyMedalWinnersController animated:YES];
			break;
		case SECTION_ALLIANCE_RANKINGS:
			; //DO NOT REMOVE
			ViewAllianceRankingsController *viewAllianceRankingsController = [ViewAllianceRankingsController create];
			switch (indexPath.row) {
				case ALLIANCE_ROW_AVERAGE_EMPIRE_SIZE:
					viewAllianceRankingsController.sortBy = @"average_empire_size_rank";
					break;
				case ALLIANCE_ROW_OFFENSIVE_SUCCESS:
					viewAllianceRankingsController.sortBy = @"offense_success_rate_rank";
					break;
				case ALLIANCE_ROW_DEFENSIVE_SUCCESS:
					viewAllianceRankingsController.sortBy = @"defense_success_rate_rank";
					break;
				case ALLIANCE_ROW_DIRTIEST:
					viewAllianceRankingsController.sortBy = @"dirtiest_rank";
					break;
			}
			[self.navigationController pushViewController:viewAllianceRankingsController animated:YES];
			break;
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
	[super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (IBAction)logout {
	Session *session = [Session sharedInstance];
	[session logout];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewStatsControllerV2 *) create {
	return [[[ViewStatsControllerV2 alloc] init] autorelease];
}


@end

