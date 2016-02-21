//
//  MakePlanViewController.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/19/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "MakePlanViewController.h"
#import "LEMacros.h"
#import "Util.h"
#import "SpaceStationLabA.h"
#import "LEBuildingMakePlan.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellPlanType.h"
#import "LETableViewCellPlanLevel.h"


typedef enum {
    SECTION_PLAN,
    SECTION_ACTIONS,
} SECTIONS;

typedef enum {
    PLAN_ROW_TYPE,
    PLAN_ROW_LEVEL,
} PLAN_ROW;


@implementation MakePlanViewController


@synthesize spaceStationLab;
@synthesize planType;
@synthesize planLevel;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Make Plan";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Resources"]);
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.spaceStationLab.types sortUsingDescriptors:_array([[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease])];
    [self.spaceStationLab.levels sortUsingDescriptors:_array([[[NSSortDescriptor alloc] initWithKey:@"level" ascending:YES] autorelease])];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SECTION_PLAN:
            return 2;
            break;
        case SECTION_ACTIONS:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SECTION_PLAN:
            switch (indexPath.row) {
                case PLAN_ROW_TYPE:
                    if (isNotNull(self.planType)) {
                        return [LETableViewCellPlanType getHeightForTableView:tableView];
                    } else {
                        return [LETableViewCellButton getHeightForTableView:tableView];
                    }
                    break;
                case PLAN_ROW_LEVEL:
                    if (isNotNull(self.planLevel)) {
                        return [LETableViewCellPlanLevel getHeightForTableView:tableView];
                    } else {
                        return [LETableViewCellButton getHeightForTableView:tableView];
                    }
                    break;
                default:
                    return 0;
                    break;
            }
            break;
        case SECTION_ACTIONS:
            return [LETableViewCellButton getHeightForTableView:tableView];
            break;
        default:
            return 0;
            break;
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case SECTION_PLAN:
            switch (indexPath.row) {
                case PLAN_ROW_TYPE:
                    if (isNotNull(self.planType)) {
                        LETableViewCellPlanType *chosenTypeCell = [LETableViewCellPlanType getCellForTableView:tableView];
                        [chosenTypeCell setPlanType:planType];
                        cell = chosenTypeCell;
                    } else {
                        LETableViewCellButton *chooseTypeCell = [LETableViewCellButton getCellForTableView:tableView];
                        chooseTypeCell.textLabel.text = @"Choose Type";
                        cell = chooseTypeCell;
                    }
                    break;
                case PLAN_ROW_LEVEL:
                    if (isNotNull(self.planLevel)) {
                        LETableViewCellPlanLevel *chosenLevelCell = [LETableViewCellPlanLevel getCellForTableView:tableView];
                        [chosenLevelCell setPlanLevel:self.planLevel];
                        cell = chosenLevelCell;
                    } else {
                        LETableViewCellButton *chooseLevelCell = [LETableViewCellButton getCellForTableView:tableView];
                        chooseLevelCell.textLabel.text = @"Choose Level";
                        cell = chooseLevelCell;
                    }
                    break;
                default:
                    break;
            }
            break;
        case SECTION_ACTIONS:
            ; //DO NOT REMVOE
            LETableViewCellButton *makePlanCell = [LETableViewCellButton getCellForTableView:tableView];
            makePlanCell.textLabel.text = @"Make Plan";
            cell = makePlanCell;
            break;
        default:
            return 0;
            break;
    }
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SECTION_PLAN:
            switch (indexPath.row) {
                case PLAN_ROW_TYPE:
                    ; //DO NOT REMOVE
                    SelectPlanTypeController *selectPlanTypeController = [SelectPlanTypeController create];
                    selectPlanTypeController.spaceStationLab = self.spaceStationLab;
                    selectPlanTypeController.delegate = self;
                    [self.navigationController pushViewController:selectPlanTypeController animated:YES];
                    break;
                case PLAN_ROW_LEVEL:
                    ; //DO NOT REMOVE
                    SelectPlanLevelController *selectPlanLevelController = [SelectPlanLevelController create];
                    selectPlanLevelController.spaceStationLab = self.spaceStationLab;
                    selectPlanLevelController.delegate = self;
                    [self.navigationController pushViewController:selectPlanLevelController animated:YES];
                    break;
                default:
                    break;
            }
            break;
        case SECTION_ACTIONS:
            if (isNotNull(self.planType) && isNotNull(self.planLevel)) {
                [self.spaceStationLab makePlanType:[self.planType objectForKey:@"type"] level:[self.planLevel objectForKey:@"level"] target:self callback:@selector(madePlan:)];
            } else {
                NSString *errorMessage;
                if (isNull(self.planType) && isNull(self.planLevel)) {
                    errorMessage = @"You must select the Type and Level to make a plan.";  
                } else if (isNull(self.planType)) {
                    errorMessage = @"You must select a Type to make a plan.";  
                } else if (isNull(self.planLevel)) {
                    errorMessage = @"You must select a Level to make a plan.";  
                } else {
                    errorMessage = @"Cannot make this plan yet.";  
                }
				UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Cannot build plans." message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
				UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
									 { [av dismissViewControllerAnimated:YES completion:nil]; }];
				[av addAction: ok];
				[self presentViewController:av animated:YES completion:nil];
            }
            break;
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
	self.spaceStationLab = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark SelectPlanTypeControllerDelegate Methods

- (void)selectedPlanType:(NSMutableDictionary *)inPlanType {
    self.planType = inPlanType;
    [self.navigationController popViewControllerAnimated:YES];
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark SelectPlanLevelControllerDelegate Methods

- (void)selectedPlanLevel:(NSMutableDictionary *)inPlanLevel {
    self.planLevel = inPlanLevel;
    [self.navigationController popViewControllerAnimated:YES];
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark Callback Methods

- (void)madePlan:(LEBuildingMakePlan *)request {
    if (![request wasError]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark -
#pragma mark Class Methods

+ (MakePlanViewController *)create {
	MakePlanViewController *makePlanViewController = [[[MakePlanViewController alloc] init] autorelease];
	return makePlanViewController;
}


@end
