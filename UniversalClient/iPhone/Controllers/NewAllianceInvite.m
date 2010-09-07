//
//  NewAllianceInvite.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "NewAllianceInvite.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "Embassy.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledTextView.h"
#import "LEBuildingCreateAlliance.h"


@implementation NewAllianceInvite


@synthesize embassy;
@synthesize messageCell;
@synthesize invitees;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"New Alliance";
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(sendInvite)] autorelease];
	
	self.messageCell = [LETableViewCellLabeledTextView getCellForTableView:self.tableView];
	self.messageCell.label.text = @"Name";
	
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"To"], [LEViewSectionTab tableView:self.tableView withText:@"Message"]);
	
	if (!self.invitees) {
		self.invitees = [NSMutableArray arrayWithCapacity:1];
	}
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


// Customize the appearance of table view cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case 1:
			return [LETableViewCellLabeledTextView getHeightForTableView:tableView];
			break;
		default:
			return 0.0;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		LETableViewCellButton *inviteeButton = [LETableViewCellButton getCellForTableView:tableView]; 
		if ([self.invitees count] > 0) {
			inviteeButton.textLabel.text = [[self.invitees objectAtIndex:0] objectForKey:@"name"];
		} else {
			inviteeButton.textLabel.text = @"Select Empire";
		}
		return inviteeButton;
	} else {
		return self.messageCell;
	}
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		SelectEmpireController *selectEmpireController = [SelectEmpireController create];
		selectEmpireController.delegate = self;
		[self.navigationController pushViewController:selectEmpireController animated:YES];
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
	self.messageCell = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.embassy = nil;
	self.invitees = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (IBAction)sendInvite {
	for (NSMutableDictionary *invitee in self.invitees) {
		[self.embassy sendInviteTo:[Util idFromDict:invitee named:@"id"] withMessage:self.messageCell.textView.text];
	}
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark SelectEmpireControllerDelegate Methods

- (void)selectedEmpire:(NSDictionary *)empire {
	[self.invitees addObject:empire];
	[self.navigationController popViewControllerAnimated:YES];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Class Methods

+ (NewAllianceInvite *)create {
	return [[[NewAllianceInvite alloc] init] autorelease];
}


@end

