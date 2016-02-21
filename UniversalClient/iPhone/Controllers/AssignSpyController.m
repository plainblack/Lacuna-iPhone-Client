//
//  AssignSpyController.m
//  UniversalClient
//
//  Created by Kevin Runde on 1/5/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "AssignSpyController.h"
#import "AppDelegate_Phone.h"
#import "Util.h"
#import "LEMacros.h"
#import "Intelligence.h"
#import "Spy.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellButton.h"


typedef enum {
	ROW_ASSIGNMENT_NAME,
	ROW_ASSIGNMENT_SKILL,
	ROW_ASSIGNMENT_DURATION,
} ROW;


@implementation AssignSpyController


@synthesize intelligence;
@synthesize spy;
@synthesize assignedMission;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Assignment";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.spy && self.spy.possibleAssignments) {
		return MAX(1, [self.spy.possibleAssignments count]);
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.spy && self.spy.possibleAssignments) {
		if ([self.spy.possibleAssignments count] > 0) {
			return 3;
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.spy && self.spy.possibleAssignments) {
		if ([self.spy.possibleAssignments count] > 0) {
			switch (indexPath.row) {
				case ROW_ASSIGNMENT_NAME:
					return [LETableViewCellButton getHeightForTableView:tableView];
					break;
				case ROW_ASSIGNMENT_SKILL:
				case ROW_ASSIGNMENT_DURATION:
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
	
	if (self.spy && self.spy.possibleAssignments) {
		if ([self.spy.possibleAssignments count] > 0) {
			NSMutableDictionary *assignment = [self.spy.possibleAssignments objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_ASSIGNMENT_NAME:
					; //DO NOT REMOVE
					LETableViewCellButton *nameCell = [LETableViewCellButton getCellForTableView:tableView];
					nameCell.textLabel.text = [assignment objectForKey:@"task"];
					cell = nameCell;
					break;
				case ROW_ASSIGNMENT_SKILL:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *skillCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					skillCell.label.text = @"Skill";
					skillCell.content.text = [Util prettyCodeValue:[assignment objectForKey:@"skill"]];
					cell = skillCell;
					break;
				case ROW_ASSIGNMENT_DURATION:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *durationCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					durationCell.label.text = @"Duration";
					durationCell.content.text = [Util prettyDuration:_intv([assignment objectForKey:@"recovery"])];
					cell = durationCell;
					break;
				default:
					cell = nil;
					break;
			}
		} else {
			LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			emptyCell.label.text = @"Trades";
			emptyCell.content.text = @"None";
			cell = emptyCell;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Trades";
		loadingCell.content.text = @"Loading";
		cell = loadingCell;
	}
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSMutableDictionary *assignment = [self.spy.possibleAssignments objectAtIndex:indexPath.section];
	switch (indexPath.row) {
		case ROW_ASSIGNMENT_NAME:
			[self.intelligence spy:self.spy assign:[assignment objectForKey:@"task"] target:self callback:@selector(spyAssigned:)];
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
	self.intelligence = nil;
	self.spy = nil;
	self.assignedMission = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callback Methods

- (void)spyAssigned:(NSMutableDictionary *)mission {
	self.assignedMission = mission;
	NSString *result = [mission objectForKey:@"result"];
	NSString *reason = [mission objectForKey:@"reason"];
	NSString *messageId = [mission objectForKey:@"message_id"];
	Spy *assignedSpy = [mission objectForKey:@"spy"];
	
	NSString *title = @"Mission Update";
	NSString *message = [NSString stringWithFormat:@"%@: %@", assignedSpy.name, reason];
	
	if ([result isEqualToString:@"Accepted"]) {
		title = @"Mission Accepted";
	} else if ([result isEqualToString:@"Success"]) {
		title = @"Mission Succeded";
	} else if ([result isEqualToString:@"Bounce"]) {
		title = @"Mission Foiled";
	} else if ([result isEqualToString:@"Failure"]) {
		title = @"Mission Failed";
	}
	
	if (isNotNull(messageId)) {
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Message", nil] autorelease];
		[av show];
	} else {
		UIAlertController *av = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
	}
}


#pragma mark -
#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	[[self navigationController] popViewControllerAnimated:YES];
	if (buttonIndex != alertView.cancelButtonIndex) {
		NSString *messageId = [self.assignedMission objectForKey:@"message_id"];
		if (messageId) {
			AppDelegate_Phone *appDelegate = (AppDelegate_Phone *)[UIApplication sharedApplication].delegate;
			[appDelegate showMessage:messageId];
		}
	}
	self.assignedMission = nil;
}


#pragma mark -
#pragma mark Class Methods

+ (AssignSpyController *)create {
	return [[[AssignSpyController alloc] init] autorelease];
}


@end

