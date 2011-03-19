//
//  ViewReservesController.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/17/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "ViewReservesController.h"
#import "LEMacros.h"
#import "Util.h"
#import "DistributionCenter.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellLabeledIconText.h"
#import "LETableViewCellLongLabeledText.h"
#import "LETableViewCellButton.h"
#import "LEBuildingReleaseReserve.h"


typedef enum {
    SECTION_RESOURCES,
    SECTION_ACTIONS,
} SECTIONS;

typedef enum {
    ACTION_ROW_SECONDS_REMAINING,
    ACTION_ROW_RELEASE,
} ACTION_ROW;


@implementation ViewReservesController


@synthesize distributionCenter;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Reserves";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Resources"]);
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.distributionCenter addObserver:self forKeyPath:@"needsRefresh" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    [self.distributionCenter.resources sortUsingDescriptors:_array([[[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES] autorelease])];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.distributionCenter removeObserver:self forKeyPath:@"needsRefresh"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SECTION_RESOURCES:
            return [self.distributionCenter.resources count];
            break;
        case SECTION_ACTIONS:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SECTION_RESOURCES:
            if ([self.distributionCenter.resources count] > 0) {
                return [LETableViewCellLongLabeledText getHeightForTableView:tableView];
            } else {
                return [LETableViewCellLabeledText getHeightForTableView:tableView];
            }
            break;
        case SECTION_ACTIONS:
            switch (indexPath.row) {
                case ACTION_ROW_SECONDS_REMAINING:
                    return [LETableViewCellLabeledText getHeightForTableView:tableView];
                    break;
                case ACTION_ROW_RELEASE:
                    return [LETableViewCellButton getHeightForTableView:tableView];
                    break;
                default:
                    return 0;
                    break;
            }
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
        case SECTION_RESOURCES:
            if ([self.distributionCenter.resources count] > 0) {
                NSMutableDictionary *tmp = [self.distributionCenter.resources objectAtIndex:indexPath.row];
                NSString *type = [tmp objectForKey:@"type"];
                NSDecimalNumber *quantity = [tmp objectForKey:@"quanity"];
                LETableViewCellLongLabeledText *resourceCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
                resourceCell.label.text = [Util prettyCodeValue:type];
                resourceCell.content.text = [Util prettyNSDecimalNumber:quantity];
                cell = resourceCell;
            } else {
                LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
                emptyCell.label.text = @"Resources";
                emptyCell.content.text = @"None";
                cell = emptyCell;
            }
            break;
        case SECTION_ACTIONS:
            switch (indexPath.row) {
                case ACTION_ROW_SECONDS_REMAINING:
                    ; // DO NOT REMOVE
                    LETableViewCellLabeledText *storageDurationCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
                    storageDurationCell.label.text = @"Reserved For";
                    storageDurationCell.content.text = [Util prettyDuration:self.distributionCenter.secondsRemaining];
                    cell = storageDurationCell;
                    break;
                case ACTION_ROW_RELEASE:
                    ; // DO NOT REMOVE
                    LETableViewCellButton *releaseButtonCell = [LETableViewCellButton getCellForTableView:tableView];
                    releaseButtonCell.textLabel.text = @"Release Reserves";
                    cell = releaseButtonCell;
                    break;
                default:
                    break;
            }
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
        case ACTION_ROW_RELEASE:
            [self.distributionCenter releaseReserveTarget:self callback:@selector(reserveReleased:)];
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
	self.distributionCenter = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callback Methods

- (void)reserveReleased:(LEBuildingReleaseReserve *)request {
    if (![request wasError]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"needsRefresh"]) {
		[self.tableView reloadData];
	}
}


#pragma mark -
#pragma mark Class Methods

+ (ViewReservesController *)create {
	ViewReservesController *viewDictionaryController = [[[ViewReservesController alloc] init] autorelease];
	return viewDictionaryController;
}


@end
