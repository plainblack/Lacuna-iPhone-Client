//
//  ViewSpiesForTrainingController.m
//  UniversalClient
//
//  Created by Kevin Runde on 5/30/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "ViewSpiesForTrainingController.h"
#import "LEMacros.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "RenameSpyController.h"
#import "AssignSpyController.h"
#import "LETableViewCellSpyInfo.h"
#import "Util.h"
#import "SpyTraining.h"
#import "Spy.h"
#import "LEBuildingTrainSpySkill.h"


typedef enum {
	ROW_SPY_INFO,
	ROW_TRAIN_BUTTON,
    ROW_COUNT
} ROW;


@interface ViewSpiesForTrainingController (PrivateMethods)

- (void)togglePageButtons;

@end


@implementation ViewSpiesForTrainingController


@synthesize pageSegmentedControl;
@synthesize spyTraining;
@synthesize spiesLastUpdated;
@synthesize selectedSpy;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Spies";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.pageSegmentedControl = [[[UISegmentedControl alloc] initWithItems:_array(UP_ARROW_ICON, DOWN_ARROW_ICON)] autorelease];
	[self.pageSegmentedControl addTarget:self action:@selector(switchPage) forControlEvents:UIControlEventValueChanged]; 
	self.pageSegmentedControl.momentary = YES;
	self.pageSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar; 
	UIBarButtonItem *rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.pageSegmentedControl] autorelease];
	self.navigationItem.rightBarButtonItem = rightBarButtonItem; 
    
	self.sectionHeaders = [NSArray array];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.spyTraining addObserver:self forKeyPath:@"spiesUpdated" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	if (!self.spyTraining.spies) {
		[self.spyTraining loadSpiesForPage:1];
	} else {
		if (self.spiesLastUpdated) {
			if ([self.spiesLastUpdated compare:self.spyTraining.spiesUpdated] == NSOrderedAscending) {
				[self.tableView reloadData];
				self.spiesLastUpdated = self.spyTraining.spiesUpdated;
			}
		} else {
			self.spiesLastUpdated = self.spyTraining.spiesUpdated;
		}
	}
    
	[self togglePageButtons];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.spyTraining removeObserver:self forKeyPath:@"spiesUpdated"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.spyTraining && self.spyTraining.spies) {
		return [self.spyTraining.spies count];
	} else {
		return 0;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ROW_COUNT;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	Spy *spy = [self.spyTraining.spies objectAtIndex:indexPath.section];
	switch (indexPath.row) {
		case ROW_SPY_INFO:
			return [LETableViewCellSpyInfo getHeightForTableView:tableView];
			break;
		case ROW_TRAIN_BUTTON:
			if (spy.isAvailable) {
				return [LETableViewCellButton getHeightForTableView:tableView];
			} else {
				return [LETableViewCellLabeledText getHeightForTableView:tableView];
			}
			break;
		default:
			return tableView.rowHeight;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	Spy *spy = [self.spyTraining.spies objectAtIndex:indexPath.section];
    
    UITableViewCell *cell = nil;
	
	switch (indexPath.row) {
		case ROW_SPY_INFO:
			; //DO NOT REMOVE
			LETableViewCellSpyInfo *spyInfoCell = [LETableViewCellSpyInfo getCellForTableView:tableView];
			[spyInfoCell setData:spy];
			cell = spyInfoCell;
			break;
		case ROW_TRAIN_BUTTON:
			if (spy.isAvailable) {
				LETableViewCellButton *trainButtonCell = [LETableViewCellButton getCellForTableView:tableView];
				trainButtonCell.textLabel.text = @"Train";
				cell = trainButtonCell;
			} else {
				LETableViewCellLabeledText *assignedCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				assignedCell.label.text = @"Busy for";
				assignedCell.content.text = [Util prettyDuration:spy.secondsRemaining];
				cell = assignedCell;
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
	Spy *spy = [self.spyTraining.spies objectAtIndex:indexPath.section];
	switch (indexPath.row) {
		case ROW_TRAIN_BUTTON:
			if (spy.isAvailable) {
                [self.spyTraining trainSpy:spy.id target:self callback:@selector(trainedSpy:)];
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
	self.pageSegmentedControl = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	self.pageSegmentedControl = nil;
	self.spyTraining = nil;
	self.spiesLastUpdated = nil;
	self.selectedSpy = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callback Methods

- (void) switchPage {
	switch (self.pageSegmentedControl.selectedSegmentIndex) {
		case 0:
			[self.spyTraining loadSpiesForPage:(self.spyTraining.spyPageNumber-1)];
			break;
		case 1:
			[self.spyTraining loadSpiesForPage:(self.spyTraining.spyPageNumber+1)];
			break;
		default:
			NSLog(@"Invalid switchPage");
			break;
	}
}


- (void)trainedSpy:(LEBuildingTrainSpySkill *)request {
    NSLog(@"Response: %@", request.response);
	if (_intv(request.notTrained) > 0) {
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your spy could not be trained. You probably don't have enough resources to train one." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[av show];
	} else {
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Training Started" message:@"Your spy is busy training." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[av show];
    }
}


#pragma mark -
#pragma mark UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.destructiveButtonIndex == buttonIndex ) {
		self.selectedSpy = nil;
	}
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


#pragma mark -
#pragma mark Private Methods

- (void)togglePageButtons {
	[self.pageSegmentedControl setEnabled:[self.spyTraining hasPreviousSpyPage] forSegmentAtIndex:0];
	[self.pageSegmentedControl setEnabled:[self.spyTraining hasNextSpyPage] forSegmentAtIndex:1];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewSpiesForTrainingController *)create {
	return [[[ViewSpiesForTrainingController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"spiesUpdated"]) {
		[self togglePageButtons];
		[self.tableView reloadData];
		self.spiesLastUpdated = self.spyTraining.spiesUpdated;
	}
}


@end
