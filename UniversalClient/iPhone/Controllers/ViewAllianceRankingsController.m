//
//  ViewAllianceRankingsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 10/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewAllianceRankingsController.h"
#import "LEMacros.h"
#import "Util.h"
#import "LEStatsAllianceRank.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellLongLabeledText.h"


typedef enum {
	ROW_ALLIANCE,
    ROW_ALLIANCE_ID,
	ROW_INFLUENCE,
	ROW_NUM_MEMBERS,
	ROW_NUM_COLONIES,
	ROW_NUM_SPACE_STATIONS,
	ROW_POPULATION,
	ROW_BUILDING_COUNT,
	ROW_AVERAGE_EMPIRE_SIZE,
	ROW_AVERAGE_BUILDING_LEVEL,
	ROW_OFFENSIVE_SUCCESS_RATE,
	ROW_DEFFENSIVE_SUCCES_RATE,
	ROW_DIRTIEST,
} ROW;


@interface ViewAllianceRankingsController (PrivateMethods)

- (void)togglePageButtons;
- (BOOL)hasNextPage;
- (BOOL)hasPreviousPage;

@end


@implementation ViewAllianceRankingsController


@synthesize pageSegmentedControl;
@synthesize sortBy;
@synthesize alliances;
@synthesize numAlliances;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if ([self.sortBy isEqualToString:@"average_empire_size_rank"]) {
		self.navigationItem.title = @"Largest Average Empires";
	} else if ([self.sortBy isEqualToString:@"offense_success_rate_rank"]) {
		self.navigationItem.title = @"Offensive Alliances";
	} else if ([self.sortBy isEqualToString:@"defense_success_rate_rank"]) {
		self.navigationItem.title = @"Defensive Alliances";
	} else if ([self.sortBy isEqualToString:@"dirtiest_rank"]) {
		self.navigationItem.title = @"Dirtiest Alliances";
	} else {
		self.navigationItem.title = @"Alliances";
	}
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.pageSegmentedControl = [[[UISegmentedControl alloc] initWithItems:_array(UP_ARROW_ICON, DOWN_ARROW_ICON)] autorelease];
	[self.pageSegmentedControl addTarget:self action:@selector(switchPage) forControlEvents:UIControlEventValueChanged]; 
	self.pageSegmentedControl.momentary = YES;
	UIBarButtonItem *rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.pageSegmentedControl] autorelease];
	self.navigationItem.rightBarButtonItem = rightBarButtonItem; 
	
	self.sectionHeaders = [NSArray array];
	
	self.navigationController.toolbar.tintColor = TINT_COLOR;
	
	self.toolbarItems = _array(
							   [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],
							   [[[UIBarButtonItem alloc] initWithTitle:@"Search for Alliance" style:UIBarButtonItemStylePlain target:self action:@selector(searchForAlliance)] autorelease],
							   [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]
							   );
	
	self->pageNumber = 1;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.navigationController setToolbarHidden:NO animated:NO];
	[self togglePageButtons];
	[[[LEStatsAllianceRank alloc] initWithCallback:@selector(alliancesLoaded:) target:self sortBy:self.sortBy pageNumber:self->pageNumber] autorelease];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.alliances) {
		if ([self.alliances count] > 0) {
			return [self.alliances count];
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.alliances) {
		if ([self.alliances count] > 0) {
			return 13;
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.alliances) {
		if ([self.alliances count] > 0) {
			switch (indexPath.row) {
				case ROW_ALLIANCE:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
                case ROW_ALLIANCE_ID:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_INFLUENCE:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_NUM_MEMBERS:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_NUM_COLONIES:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_NUM_SPACE_STATIONS:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_POPULATION:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_BUILDING_COUNT:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_AVERAGE_EMPIRE_SIZE:
					return [LETableViewCellLongLabeledText getHeightForTableView:tableView];
					break;
				case ROW_AVERAGE_BUILDING_LEVEL:
					return [LETableViewCellLongLabeledText getHeightForTableView:tableView];
					break;
				case ROW_OFFENSIVE_SUCCESS_RATE:
					return [LETableViewCellLongLabeledText getHeightForTableView:tableView];
					break;
				case ROW_DEFFENSIVE_SUCCES_RATE:
					return [LETableViewCellLongLabeledText getHeightForTableView:tableView];
					break;
				case ROW_DIRTIEST:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				default:
					return 0.0;
					break;
			}
		} else {
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
		}
	} else {
		return [LETableViewCellLabeledText getHeightForTableView:tableView];
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
	
	if (self.alliances) {
		if ([self.alliances count] > 0) {
			NSMutableDictionary *alliance = [self.alliances objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_ALLIANCE:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *allianceCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					allianceCell.label.text = @"Alliance";
					allianceCell.content.text = [alliance objectForKey:@"alliance_name"];
					cell = allianceCell;
					break;
                case ROW_ALLIANCE_ID:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *allianceidCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					allianceidCell.label.text = @"Alliance ID";
					allianceidCell.content.text = [Util asString:[alliance objectForKey:@"alliance_id"]];
					cell = allianceidCell;
					break;
				case ROW_INFLUENCE:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *influenceCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					influenceCell.label.text = @"Influence";
					influenceCell.content.text = [Util prettyNSDecimalNumber:[Util asNumber:[alliance objectForKey:@"influence"]]];
					cell = influenceCell;
					break;
				case ROW_NUM_MEMBERS:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *numMembersCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					numMembersCell.label.text = @"Members";
					numMembersCell.content.text = [Util prettyNSDecimalNumber:[Util asNumber:[alliance objectForKey:@"member_count"]]];
					cell = numMembersCell;
					break;
				case ROW_NUM_COLONIES:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *numColoniesCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					numColoniesCell.label.text = @"Colonies";
					numColoniesCell.content.text = [Util prettyNSDecimalNumber:[Util asNumber:[alliance objectForKey:@"colony_count"]]];
					cell = numColoniesCell;
					break;
				case ROW_NUM_SPACE_STATIONS:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *numSpaceStationsCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					numSpaceStationsCell.label.text = @"Space Stations";
					numSpaceStationsCell.content.text = [Util prettyNSDecimalNumber:[Util asNumber:[alliance objectForKey:@"space_station_count"]]];
					cell = numSpaceStationsCell;
					break;
				case ROW_POPULATION:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *populationCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					populationCell.label.text = @"Population";
					populationCell.content.text = [Util prettyNSDecimalNumber:[Util asNumber:[alliance objectForKey:@"population"]]];
					cell = populationCell;
					break;
				case ROW_BUILDING_COUNT:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *buildingCountCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					buildingCountCell.label.text = @"Buildings";
					buildingCountCell.content.text = [Util prettyNSDecimalNumber:[Util asNumber:[alliance objectForKey:@"building_count"]]];
					cell = buildingCountCell;
					break;
				case ROW_AVERAGE_EMPIRE_SIZE:
					; //DO NOT REMOVE
					LETableViewCellLongLabeledText *averageEmpireSizeCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
					averageEmpireSizeCell.label.text = @"Average Empire Size";
					averageEmpireSizeCell.content.text = [Util prettyNSDecimalNumber:[Util asNumber:[alliance objectForKey:@"average_empire_size"]]];
					cell = averageEmpireSizeCell;
					break;
				case ROW_AVERAGE_BUILDING_LEVEL:
					; //DO NOT REMOVE
					LETableViewCellLongLabeledText *averageBuildingLevelCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
					averageBuildingLevelCell.label.text = @"Average Building Level";
					averageBuildingLevelCell.content.text = [Util prettyNSDecimalNumber:[Util asNumber:[alliance objectForKey:@"average_building_level"]]];
					cell = averageBuildingLevelCell;
					break;
				case ROW_OFFENSIVE_SUCCESS_RATE:
					; //DO NOT REMOVE
					LETableViewCellLongLabeledText *offensiveSuccessRateCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
					offensiveSuccessRateCell.label.text = @"Offensive Success Rate";
					offensiveSuccessRateCell.content.text = [NSString stringWithFormat:@"%@%%", [Util prettyNSDecimalNumber:[[Util asNumber:[alliance objectForKey:@"offense_success_rate"]] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]]]];
					cell = offensiveSuccessRateCell;
					break;
				case ROW_DEFFENSIVE_SUCCES_RATE:
					; //DO NOT REMOVE
					LETableViewCellLongLabeledText *defensiveSuccessRateCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
					defensiveSuccessRateCell.label.text = @"Defensive Success Rate";
					defensiveSuccessRateCell.content.text = [NSString stringWithFormat:@"%@%%", [Util prettyNSDecimalNumber:[[Util asNumber:[alliance objectForKey:@"defense_success_rate"]] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]]]];
					cell = defensiveSuccessRateCell;
					break;
				case ROW_DIRTIEST:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *dirtiestCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					dirtiestCell.label.text = @"Dirtiest";
					dirtiestCell.content.text = [Util prettyNSDecimalNumber:[Util asNumber:[alliance objectForKey:@"dirtiest"]]];
					cell = dirtiestCell;
					break;
				default:
					cell = nil;
					break;
			}
		} else {
			LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			emptyCell.label.text = @"Alliances";
			emptyCell.content.text = @"None";
			cell = emptyCell;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Alliances";
		loadingCell.content.text = @"Loading";
		cell = loadingCell;
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
	self.pageSegmentedControl = nil;
	self.alliances = nil;
	self.numAlliances = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	self.sortBy = nil;
	self.pageSegmentedControl = nil;
	self.alliances = nil;
	self.numAlliances = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark SearchForAllianceInRankingsControllerDelegate Methods

- (void)selectedAlliance:(NSDictionary *)alliance {
	[self.navigationController popViewControllerAnimated:YES];
	self->pageNumber = _intv([alliance objectForKey:@"page_number"]);
	[self togglePageButtons];
	[[[LEStatsAllianceRank alloc] initWithCallback:@selector(alliancesLoaded:) target:self sortBy:self.sortBy pageNumber:self->pageNumber] autorelease];
}


#pragma mark -
#pragma mark Private Methods

- (void)togglePageButtons {
	[self.pageSegmentedControl setEnabled:[self hasPreviousPage] forSegmentAtIndex:0];
	[self.pageSegmentedControl setEnabled:[self hasNextPage] forSegmentAtIndex:1];
}


- (BOOL)hasNextPage {
	return (self->pageNumber < [Util numPagesForCount:_intv(self.numAlliances)]);
}


- (BOOL)hasPreviousPage {
	return (self->pageNumber > 1);
}


#pragma mark -
#pragma mark Callback Methods

- (id)alliancesLoaded:(LEStatsAllianceRank *)request {
	self.alliances = request.alliances;
	self.numAlliances = request.numAlliances;
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[self.alliances count]];
	for (int i=0; i < [self.alliances count]; i++) {
		[tmp addObject:[LEViewSectionTab tableView:self.tableView withText:[NSString stringWithFormat:@"Alliance %i", ((request.pageNumber-1)*25+i+1)]]];
	}
	self.sectionHeaders = tmp;
	[self togglePageButtons];
	[self.tableView reloadData];
	return nil;
}


- (void) switchPage {
	switch (self.pageSegmentedControl.selectedSegmentIndex) {
		case 0:
			self->pageNumber--;
			[[[LEStatsAllianceRank alloc] initWithCallback:@selector(alliancesLoaded:) target:self sortBy:self.sortBy pageNumber:self->pageNumber] autorelease];
			break;
		case 1:
			self->pageNumber++;
			[[[LEStatsAllianceRank alloc] initWithCallback:@selector(alliancesLoaded:) target:self sortBy:self.sortBy pageNumber:self->pageNumber] autorelease];
			break;
		default:
			NSLog(@"Invalid switchPage");
			break;
	}
	[self togglePageButtons];
}


- (void) searchForAlliance {
	NSLog(@"Search called");
	SearchForAllianceInRankingsController *searchForAllianceInRankingsController = [SearchForAllianceInRankingsController create];
	searchForAllianceInRankingsController.sortBy = self.sortBy;
	searchForAllianceInRankingsController.delegate = self;
	[self.navigationController pushViewController:searchForAllianceInRankingsController animated:YES];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewAllianceRankingsController *)create {
	return [[[ViewAllianceRankingsController alloc] init] autorelease];
}


@end

