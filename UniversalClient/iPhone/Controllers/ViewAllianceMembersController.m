//
//  ViewAllianceMembersController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewAllianceMembersController.h"
#import "LEMacros.h"
#import "Session.h"
#import "Embassy.h"
#import "AllianceStatus.h"
#import "AllianceMember.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellButton.h"
#import "ExpelAllianceMemberController.h"
#import "PromoteAllianceMemberController.h"


typedef enum {
	ROW_TO,
	ROW_EXPEL,
	ROW_PROMOTE
} ROW;


@implementation ViewAllianceMembersController


@synthesize embassy;
@synthesize watchedAllianceStatus;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Members";
	
	self.sectionHeaders = nil;
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.embassy addObserver:self forKeyPath:@"allianceStatus" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	if (self.embassy.allianceStatus) {
		self.watchedAllianceStatus = self.embassy.allianceStatus;
		[self.watchedAllianceStatus addObserver:self forKeyPath:@"members" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
		[self.watchedAllianceStatus addObserver:self forKeyPath:@"dateLoaded" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	}
	self->watched = YES;
	[self.tableView reloadData];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	if (self->watched) {
		[self.embassy removeObserver:self forKeyPath:@"allianceStatus"];
		if (self.watchedAllianceStatus) {
			[self.watchedAllianceStatus removeObserver:self forKeyPath:@"members"];
			[self.watchedAllianceStatus removeObserver:self forKeyPath:@"dateLoaded"];
			self.watchedAllianceStatus = nil;
		}
		self->watched = NO;
	}
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.watchedAllianceStatus.members) {
		if ([self.watchedAllianceStatus.members count] > 0) {
			return [self.watchedAllianceStatus.members count];
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.watchedAllianceStatus.members) {
		if ([self.watchedAllianceStatus.members count] > 0) {
			return 3;
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.watchedAllianceStatus.members) {
		if ([self.watchedAllianceStatus.members count] > 0) {
			switch (indexPath.row) {
				case ROW_TO:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_EXPEL:
				case ROW_PROMOTE:
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
	UITableViewCell *cell = nil;
	
	if (self.watchedAllianceStatus.members) {
		if ([self.watchedAllianceStatus.members count] > 0) {
			AllianceMember *member = [self.watchedAllianceStatus.members objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_TO:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *toCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					toCell.label.text = @"Empire";
					toCell.content.text = member.name;
					cell = toCell;
					break;
				case ROW_EXPEL:
					; //DO NOT REMOVE
					LETableViewCellButton *expelButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					expelButtonCell.textLabel.text = @"Expel";
					cell = expelButtonCell;
					break;
				case ROW_PROMOTE:
					; //DO NOT REMOVE
					LETableViewCellButton *promoteButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					promoteButtonCell.textLabel.text = @"Promote to leader";
					cell = promoteButtonCell;
					break;
				default:
					cell = nil;
					break;
			}
		} else {
			LETableViewCellLabeledText *noneCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			noneCell.label.text = @"Members";
			noneCell.content.text = @"None";
			cell = noneCell;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Members";
		loadingCell.content.text = @"Loading";
		cell = loadingCell;
	}
	
	return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.watchedAllianceStatus.members) {
		if ([self.watchedAllianceStatus.members count] > 0) {
			AllianceMember *member = [self.watchedAllianceStatus.members objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_EXPEL:
					; // DO NOT REMOVE
					ExpelAllianceMemberController *expelAllianceMemberController = [ExpelAllianceMemberController create];
					expelAllianceMemberController.embassy = self.embassy;
					expelAllianceMemberController.member = member;
					[self.navigationController pushViewController:expelAllianceMemberController animated:YES];
					break;
				case ROW_PROMOTE:
					; // DO NOT REMOVE
					PromoteAllianceMemberController *promoteAllianceMemberController = [PromoteAllianceMemberController create];
					promoteAllianceMemberController.embassy = self.embassy;
					promoteAllianceMemberController.member = member;
					[self.navigationController pushViewController:promoteAllianceMemberController animated:YES];
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
	if (self->watched) {
		[self.embassy removeObserver:self forKeyPath:@"allianceStatus"];
		if (self.watchedAllianceStatus) {
			[self.watchedAllianceStatus removeObserver:self forKeyPath:@"members"];
			[self.watchedAllianceStatus removeObserver:self forKeyPath:@"dateLoaded"];
			self.watchedAllianceStatus = nil;
		}
		self->watched = NO;
	}
    [super viewDidUnload];
}


- (void)dealloc {
	if (self->watched) {
		[self.embassy removeObserver:self forKeyPath:@"allianceStatus"];
		if (self.watchedAllianceStatus) {
			[self.watchedAllianceStatus removeObserver:self forKeyPath:@"members"];
			[self.watchedAllianceStatus removeObserver:self forKeyPath:@"dateLoaded"];
			self.watchedAllianceStatus = nil;
		}
		self->watched = NO;
	}
	self.embassy = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewAllianceMembersController *)create {
	return [[[ViewAllianceMembersController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	NSLog(@"keyPath: %@", keyPath);
	if ([keyPath isEqual:@"allianceStatus"]) {
		if (self.watchedAllianceStatus) {
			[self.watchedAllianceStatus removeObserver:self forKeyPath:@"members"];
			[self.watchedAllianceStatus removeObserver:self forKeyPath:@"dateLoaded"];
			self.watchedAllianceStatus = nil;
		}
		
		if (self.embassy.allianceStatus) {
			self.watchedAllianceStatus = self.embassy.allianceStatus;
			[self.watchedAllianceStatus addObserver:self forKeyPath:@"members" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
			[self.watchedAllianceStatus addObserver:self forKeyPath:@"dateLoaded" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
			self->watched = YES;
		} else {
			self->watched = NO;
		}

		[self.tableView reloadData];
	} else if ([keyPath isEqual:@"members"]) {
		[self.tableView reloadData];
	} else if ([keyPath isEqual:@"dateLoaded"]) {
		[self.tableView reloadData];
	}
}


@end

