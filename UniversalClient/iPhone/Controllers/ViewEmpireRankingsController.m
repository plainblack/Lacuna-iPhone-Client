//
//  ViewEmpireRankingsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewEmpireRankingsController.h"
#import "LEMacros.h"
#import "Util.h"
#import "LEStatsEmpireRank.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellLongLabeledText.h"


typedef enum {
	ROW_EMPIRE,
    ROW_EMPIRE_ID,
    ROW_ALLIANCE, 
	ROW_NUM_COLONIES,
	ROW_POPULATION,
	ROW_EMPIRE_SIZE,
	ROW_BUILDING_COUNT,
	ROW_AVERAGE_BUILDING_LEVEL,
	ROW_OFFENSIVE_SUCCESS_RATE,
	ROW_DEFFENSIVE_SUCCES_RATE,
	ROW_DIRTIEST,
} ROW;


@interface ViewEmpireRankingsController (PrivateMethods)

- (void)togglePageButtons;
- (BOOL)hasNextPage;
- (BOOL)hasPreviousPage;

@end


@implementation ViewEmpireRankingsController


@synthesize pageSegmentedControl;
@synthesize sortBy;
@synthesize empires;
@synthesize numEmpires;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if ([self.sortBy isEqualToString:@"empire_size_rank"]) {
		self.navigationItem.title = @"Largest Empires";
	} else if ([self.sortBy isEqualToString:@"offense_success_rate_rank"]) {
		self.navigationItem.title = @"Offensive Empires";
	} else if ([self.sortBy isEqualToString:@"defense_success_rate_rank"]) {
		self.navigationItem.title = @"Defensive Empires";
	} else if ([self.sortBy isEqualToString:@"dirtiest_rank"]) {
		self.navigationItem.title = @"Dirtiest Empires";
	} else {
		self.navigationItem.title = @"Empires";
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
		[[[UIBarButtonItem alloc] initWithTitle:@"Search for Empire" style:UIBarButtonItemStylePlain target:self action:@selector(searchForEmpire)] autorelease],
		[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]
	);
	
	self->pageNumber = 1;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.navigationController setToolbarHidden:NO animated:NO];
	[self togglePageButtons];
	[[[LEStatsEmpireRank alloc] initWithCallback:@selector(empiresLoaded:) target:self sortBy:self.sortBy pageNumber:self->pageNumber] autorelease];
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
	if (self.empires) {
		if ([self.empires count] > 0) {
			return [self.empires count];
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.empires) {
		if ([self.empires count] > 0) {
			return 11;
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.empires) {
		if ([self.empires count] > 0) {
			switch (indexPath.row) {
				case ROW_EMPIRE:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_EMPIRE_ID:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_ALLIANCE:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_NUM_COLONIES:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_POPULATION:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_EMPIRE_SIZE:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_BUILDING_COUNT:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
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


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
	
	if (self.empires) {
		if ([self.empires count] > 0) {
			NSMutableDictionary *empire = [self.empires objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_EMPIRE:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *empireCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					empireCell.label.text = @"Empire";
					empireCell.content.text = [empire objectForKey:@"empire_name"];
					cell = empireCell;
					break;
                case ROW_EMPIRE_ID:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *empireidCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					empireidCell.label.text = @"Empire ID";
					empireidCell.content.text =  [Util asString:[empire objectForKey:@"empire_id"]];
					cell = empireidCell;
					break;
                case ROW_ALLIANCE:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *allianceCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					allianceCell.label.text = @"Alliance";
					allianceCell.content.text = [empire objectForKey:@"alliance_name"];
					cell = allianceCell;
					break;
				case ROW_NUM_COLONIES:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *numColoniesCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					numColoniesCell.label.text = @"# Colonies";
					numColoniesCell.content.text =  [Util prettyNSDecimalNumber:[Util asNumber:[empire objectForKey:@"colony_count"]]];
					cell = numColoniesCell;
					break;
				case ROW_POPULATION:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *populationCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					populationCell.label.text = @"Population";
					populationCell.content.text = [Util prettyNSDecimalNumber:[Util asNumber:[empire objectForKey:@"population"]]];
					cell = populationCell;
					break;
				case ROW_EMPIRE_SIZE:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *empireSizeCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					empireSizeCell.label.text = @"Empire Size";
					empireSizeCell.content.text = [Util prettyNSDecimalNumber:[Util asNumber:[empire objectForKey:@"empire_size"]]];
					cell = empireSizeCell;
					break;
				case ROW_BUILDING_COUNT:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *buildingCountCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					buildingCountCell.label.text = @"# Buildings";
					buildingCountCell.content.text = [Util prettyNSDecimalNumber:[Util asNumber:[empire objectForKey:@"building_count"]]];
					cell = buildingCountCell;
					break;
				case ROW_AVERAGE_BUILDING_LEVEL:
					; //DO NOT REMOVE
					LETableViewCellLongLabeledText *averageBuildingLevelCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
					averageBuildingLevelCell.label.text = @"Average Building Level";
					averageBuildingLevelCell.content.text = [Util prettyNSDecimalNumber:[Util asNumber:[empire objectForKey:@"average_building_level"]]];
					cell = averageBuildingLevelCell;
					break;
				case ROW_OFFENSIVE_SUCCESS_RATE:
					; //DO NOT REMOVE
					LETableViewCellLongLabeledText *offensiveSuccessRateCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
					offensiveSuccessRateCell.label.text = @"Offensive Success Rate";
					offensiveSuccessRateCell.content.text = [NSString stringWithFormat:@"%@%%", [Util prettyNSDecimalNumber:[[Util asNumber:[empire objectForKey:@"offense_success_rate"]] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]]]];
					cell = offensiveSuccessRateCell;
					break;
				case ROW_DEFFENSIVE_SUCCES_RATE:
					; //DO NOT REMOVE
					LETableViewCellLongLabeledText *defensiveSuccessRateCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
					defensiveSuccessRateCell.label.text = @"Defensive Success Rate";
					defensiveSuccessRateCell.content.text = [NSString stringWithFormat:@"%@%%", [Util prettyNSDecimalNumber:[[Util asNumber:[empire objectForKey:@"defense_success_rate"]] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]]]];
					cell = defensiveSuccessRateCell;
					break;
				case ROW_DIRTIEST:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *dirtiestCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					dirtiestCell.label.text = @"Dirtiest";
					dirtiestCell.content.text = [Util prettyNSDecimalNumber:[Util asNumber:[empire objectForKey:@"dirtiest"]]];
					cell = dirtiestCell;
					break;
				default:
					cell = nil;
					break;
			}
		} else {
			LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			emptyCell.label.text = @"Empires";
			emptyCell.content.text = @"None";
			cell = emptyCell;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Empires";
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
	self.empires = nil;
	self.numEmpires = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	self.sortBy = nil;
	self.pageSegmentedControl = nil;
	self.empires = nil;
	self.numEmpires = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark SearchForEmpireInRankingsControllerDelegate Methods

- (void)selectedEmpire:(NSDictionary *)empire {
	[self.navigationController popViewControllerAnimated:YES];
	self->pageNumber = _intv([empire objectForKey:@"page_number"]);
	[self togglePageButtons];
	[[[LEStatsEmpireRank alloc] initWithCallback:@selector(empiresLoaded:) target:self sortBy:self.sortBy pageNumber:self->pageNumber] autorelease];
}


#pragma mark -
#pragma mark Private Methods

- (void)togglePageButtons {
	[self.pageSegmentedControl setEnabled:[self hasPreviousPage] forSegmentAtIndex:0];
	[self.pageSegmentedControl setEnabled:[self hasNextPage] forSegmentAtIndex:1];
}


- (BOOL)hasNextPage {
	return (self->pageNumber < [Util numPagesForCount:_intv(self.numEmpires)]);
}


- (BOOL)hasPreviousPage {
	return (self->pageNumber > 1);
}


#pragma mark -
#pragma mark Callback Methods

- (id)empiresLoaded:(LEStatsEmpireRank *)request {
	self.empires = request.empires;
	self.numEmpires = request.numEmpires;
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[self.empires count]];
	for (int i=0; i < [self.empires count]; i++) {
		[tmp addObject:[LEViewSectionTab tableView:self.tableView withText:[NSString stringWithFormat:@"Empire %i", ((request.pageNumber-1)*25+i+1)]]];
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
			[[[LEStatsEmpireRank alloc] initWithCallback:@selector(empiresLoaded:) target:self sortBy:self.sortBy pageNumber:self->pageNumber] autorelease];
			break;
		case 1:
			self->pageNumber++;
			[[[LEStatsEmpireRank alloc] initWithCallback:@selector(empiresLoaded:) target:self sortBy:self.sortBy pageNumber:self->pageNumber] autorelease];
			break;
		default:
			NSLog(@"Invalid switchPage");
			break;
	}
	[self togglePageButtons];
}


- (void) searchForEmpire {
	NSLog(@"Search called");
	SearchForEmpireInRankingsController *searchForEmpireInRankingsController = [SearchForEmpireInRankingsController create];
	searchForEmpireInRankingsController.sortBy = self.sortBy;
	searchForEmpireInRankingsController.delegate = self;
	[self.navigationController pushViewController:searchForEmpireInRankingsController animated:YES];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewEmpireRankingsController *)create {
	return [[[ViewEmpireRankingsController alloc] init] autorelease];
}


@end

