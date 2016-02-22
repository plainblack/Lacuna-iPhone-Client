//
//  ViewProbedStarsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewProbedStarsController.h"
#import "AppDelegate_Phone.h"
#import "LEMacros.h"
#import "Util.h"
#import "Observatory.h"
#import "Star.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellStar.h"
#import "LETableViewCellButton.h"


typedef enum {
	ROW_PROBED_STAR,
	ROW_ABANDON_PROBE
} ROW;


@interface ViewProbedStarsController (PrivateMethods)

- (void)togglePageButtons;

@end


@implementation ViewProbedStarsController


@synthesize pageSegmentedControl;
@synthesize observatory;
@synthesize selectedStar;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Probed Stars";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.pageSegmentedControl = [[[UISegmentedControl alloc] initWithItems:_array(UP_ARROW_ICON, DOWN_ARROW_ICON)] autorelease];
	[self.pageSegmentedControl addTarget:self action:@selector(switchPage) forControlEvents:UIControlEventValueChanged]; 
	self.pageSegmentedControl.momentary = YES;
	UIBarButtonItem *rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.pageSegmentedControl] autorelease];
	self.navigationItem.rightBarButtonItem = rightBarButtonItem; 
	
	self.sectionHeaders = [NSArray array];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.observatory addObserver:self forKeyPath:@"probedStars" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	if (!self.observatory.probedStars) {
		[self.observatory loadProbedStarsForPage:1];
	}

	[self togglePageButtons];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.observatory removeObserver:self forKeyPath:@"probedStars"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.observatory && self.observatory.probedStars) {
		if ([self.observatory.probedStars count] > 0) {
			return [self.observatory.probedStars count];
		} else {
			return 1;
		}
		
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.observatory && self.observatory.probedStars) {
		if ([self.observatory.probedStars count] > 0) {
			return 2;
		} else {
			return 1;
		}
		
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.observatory && self.observatory.probedStars) {
		if ([self.observatory.probedStars count] > 0) {
			switch (indexPath.row) {
				case ROW_PROBED_STAR:
					return [LETableViewCellStar getHeightForTableView:tableView];
					break;
				case ROW_ABANDON_PROBE:
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
	
	if (self.observatory && self.observatory.probedStars) {
		if ([self.observatory.probedStars count] > 0) {
			Star *star = [self.observatory.probedStars objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_PROBED_STAR:
					; //DO NOT REMOVE
					LETableViewCellStar *starCell = [LETableViewCellStar getCellForTableView:tableView isSelectable:YES];
					[starCell setStar:star];
					cell = starCell;
					break;
				case ROW_ABANDON_PROBE:
					; //DO NOT REMOVE
					LETableViewCellButton *abandonCell = [LETableViewCellButton getCellForTableView:tableView];
					abandonCell.textLabel.text = @"Abandon";
					cell = abandonCell;
					break;
				default:
					cell = nil;
					break;
			}
		} else {
			LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			loadingCell.label.text = @"Probed";
			loadingCell.content.text = @"None";
			cell = loadingCell;
		}
		
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"";
		loadingCell.content.text = @"Loading";
		cell = loadingCell;
	}
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.observatory && self.observatory.probedStars) {
		if ([self.observatory.probedStars count] > 0) {
			Star *star = [self.observatory.probedStars objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_PROBED_STAR:
					; //DO NOT REMOVE
					AppDelegate_Phone *appDelegate = (AppDelegate_Phone *)[UIApplication sharedApplication].delegate;
					[appDelegate showStarMapGridX:star.x gridY:star.y];
					break;
				case ROW_ABANDON_PROBE:
					self.selectedStar = star;
					UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Abandon Star %@?", star.name] message:@"" preferredStyle:UIAlertControllerStyleAlert];
					UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
						[self.observatory abandonProbeAtStar:self.selectedStar.id];
						self.selectedStar = nil;
						[self.navigationController popViewControllerAnimated:YES];
					}];
					UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
					}];
					[alert addAction:cancelAction];
					[alert addAction:okAction];
					[self presentViewController:alert animated:YES completion:nil];
					break;
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
	self.pageSegmentedControl = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.pageSegmentedControl = nil;
	self.observatory = nil;
	self.selectedStar = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callback Methods

- (void) switchPage {
	switch (self.pageSegmentedControl.selectedSegmentIndex) {
		case 0:
			[self.observatory loadProbedStarsForPage:(self.observatory.probedStarsPageNumber-1)];
			break;
		case 1:
			[self.observatory loadProbedStarsForPage:(self.observatory.probedStarsPageNumber+1)];
			break;
		default:
			NSLog(@"Invalid switchPage");
			break;
	}
}


#pragma mark -
#pragma mark Private Methods

- (void)togglePageButtons {
	[self.pageSegmentedControl setEnabled:[self.observatory hasPreviousProbedStarsPage] forSegmentAtIndex:0];
	[self.pageSegmentedControl setEnabled:[self.observatory hasNextProbedStarsPage] forSegmentAtIndex:1];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewProbedStarsController *)create {
	return [[[ViewProbedStarsController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"probedStars"]) {
		[self togglePageButtons];
		[self.tableView reloadData];
	}
}


@end

