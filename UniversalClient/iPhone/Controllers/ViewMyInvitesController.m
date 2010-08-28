//
//  ViewMyInvitesContorller.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewMyInvitesController.h"
#import "LEMacros.h"
#import "Session.h"
#import "Embassy.h"
#import "MyAllianceInvite.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellButton.h"
#import "AcceptAllianceInviteController.h"
#import "RejectAllianceInviteController.h"


typedef enum {
	ROW_TO,
	ROW_ACCEPT,
	ROW_REJECT
} ROW;


@implementation ViewMyInvitesController


@synthesize embassy;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"My Invites";
	
	self.sectionHeaders = nil;
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self->watched = YES;
	[self.embassy addObserver:self forKeyPath:@"myInvites" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self.embassy loadMyInvites];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	if (self ->watched) {
		[self.embassy removeObserver:self forKeyPath:@"myInvites"];
		self->watched = NO;
	}
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.embassy.myInvites) {
		if ([self.embassy.myInvites count] > 0) {
			return [self.embassy.myInvites count];
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.embassy.myInvites) {
		if ([self.embassy.myInvites count] > 0) {
			return 3;
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.embassy.myInvites) {
		if ([self.embassy.myInvites count] > 0) {
			switch (indexPath.row) {
				case ROW_TO:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_ACCEPT:
				case ROW_REJECT:
					return [LETableViewCellButton getHeightForTableView:tableView];
					break;
				default:
					return 0;
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
	UITableViewCell *cell;
	
	if (self.embassy.myInvites) {
		if ([self.embassy.myInvites count] > 0) {
			MyAllianceInvite *invite = [self.embassy.myInvites objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_TO:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *toCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					toCell.label.text = @"Alliance";
					toCell.content.text = invite.name;
					cell = toCell;
					break;
				case ROW_ACCEPT:
					; //DO NOT REMOVE
					LETableViewCellButton *acceptButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					acceptButtonCell.textLabel.text = @"Accept";
					cell = acceptButtonCell;
					break;
				case ROW_REJECT:
					; //DO NOT REMOVE
					LETableViewCellButton *rejectButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					rejectButtonCell.textLabel.text = @"Reject";
					cell = rejectButtonCell;
					break;
				default:
					cell = nil;
					break;
			}
		} else {
			LETableViewCellLabeledText *noneCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			noneCell.label.text = @"Invites";
			noneCell.content.text = @"None";
			cell = noneCell;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Invites";
		loadingCell.content.text = @"Loading";
		cell = loadingCell;
	}
	
	return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.embassy.myInvites) {
		if ([self.embassy.myInvites count] > 0) {
			MyAllianceInvite *invite = [self.embassy.myInvites objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_ACCEPT:
					; // DO NOT REMOVE
					AcceptAllianceInviteController *acceptAllianceInviteController = [AcceptAllianceInviteController create];
					acceptAllianceInviteController.embassy = self.embassy;
					acceptAllianceInviteController.invite = invite;
					[self.navigationController pushViewController:acceptAllianceInviteController animated:YES];
					break;
				case ROW_REJECT:
					; // DO NOT REMOVE
					RejectAllianceInviteController *rejectAllianceInviteController = [RejectAllianceInviteController create];
					rejectAllianceInviteController.embassy = self.embassy;
					rejectAllianceInviteController.invite = invite;
					[self.navigationController pushViewController:rejectAllianceInviteController animated:YES];
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
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	if (self ->watched) {
		[self.embassy removeObserver:self forKeyPath:@"myInvites"];
		self->watched = NO;
	}
}


- (void)dealloc {
	self.embassy = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewMyInvitesController *)create {
	return [[[ViewMyInvitesController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"myInvites"]) {
		[self.tableView reloadData];
	}
}


@end

