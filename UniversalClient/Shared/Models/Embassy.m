//
//  Embassy.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/23/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Embassy.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "AllianceStatus.h"
#import "PendingAllianceInvite.h"
#import "MyAllianceInvite.h"
#import "LEBuildingAcceptInvite.h"
#import "LEBuildingAssignAllianceLeader.h"
#import "LEBuildingCreateAlliance.h"
#import "LEBuildingDissolveAlliance.h"
#import "LEBuildingExpelMember.h"
#import "LEBuildingGetAllianceStatus.h"
#import "LEBuildingGetPendingInvites.h"
#import "LEBuildingGetMyInvites.h"
#import "LEBuildingLeaveAlliance.h"
#import "LEBuildingRejectInvite.h"
#import "LEBuildingSendInvite.h"
#import "LEBuildingUpdateAlliance.h"
#import "LEBuildingWithdrawInvite.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellLabeledParagraph.h"
#import "NewAllianceController.h"
#import	"DisolveAllianceController.h"
#import "NewAllianceInvite.h"
#import "ViewPendingInvitesController.h"
#import "ViewMyInvitesController.h"


@implementation Embassy


@synthesize allianceStatus;
@synthesize pendingInvites;
@synthesize myInvites;


#pragma mark --
#pragma mark Object Methods

- (void)dealloc {
	self.allianceStatus = nil;
	self.pendingInvites = nil;
	self.myInvites = nil;
	[super dealloc];
}


#pragma mark --
#pragma mark Overriden Building Methods

- (void)tick:(NSInteger)interval {
	[super tick:interval];
}


- (void)parseAdditionalData:(NSDictionary *)data {
	if (!self.allianceStatus) {
		self.allianceStatus = [[[AllianceStatus alloc] init] autorelease];
	}
	NSMutableDictionary *allianceStatusData = [data objectForKey:@"alliance_status"];
	if (allianceStatusData) {
		[self.allianceStatus parseData:allianceStatusData];
	}
}


- (void)generateSections {
	NSMutableArray *tmp = _array([self generateProductionSection]);
	
	if (self.allianceStatus.id) {
		[tmp addObject:_dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ALLIANCE_STATUS], @"type", @"Alliance", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_ALLIANCE_NAME], [NSDecimalNumber numberWithInt:BUILDING_ROW_ALLIANCE_LEADER], [NSDecimalNumber numberWithInt:BUILDING_ROW_ALLIANCE_DESCRIPTION], [NSDecimalNumber numberWithInt:BUILDING_ROW_ALLIANCE_ANNOUNCEMENTS], [NSDecimalNumber numberWithInt:BUILDING_ROW_ALLIANCE_FORUM], [NSDecimalNumber numberWithInt:BUILDING_ROW_ALLIANCE_CREATED_ON]), @"rows")];
		Session *session = [Session sharedInstance];
		if ([session.empire.id isEqualToString:self.allianceStatus.leaderId]) {
			[tmp addObject:_dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_CREATE_INVITE], [NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_PENDING_INVITES], [NSDecimalNumber numberWithInt:BUILDING_ROW_UPDATE_ALLIANCE], [NSDecimalNumber numberWithInt:BUILDING_ROW_DISOLVE_ALLIANCE], [NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_MY_INVITES]), @"rows")];
		} else {
			[tmp addObject:_dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_LEAVE_ALLIANCE], [NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_MY_INVITES]), @"rows")];
		}
	} else {
		[tmp addObject:_dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_MY_INVITES], [NSDecimalNumber numberWithInt:BUILDING_ROW_CREATE_ALLIANCE]), @"rows")];
	}
	
	[tmp addObject:[self generateHealthSection]];
	[tmp addObject:[self generateUpgradeSection]];
	self.sections = tmp;
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_MY_INVITES:
		case BUILDING_ROW_CREATE_ALLIANCE:
		case BUILDING_ROW_LEAVE_ALLIANCE:
		case BUILDING_ROW_CREATE_INVITE:
		case BUILDING_ROW_VIEW_PENDING_INVITES:
		case BUILDING_ROW_UPDATE_ALLIANCE:
		case BUILDING_ROW_DISOLVE_ALLIANCE:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_ALLIANCE_NAME:
		case BUILDING_ROW_ALLIANCE_LEADER:
		case BUILDING_ROW_ALLIANCE_FORUM:
		case BUILDING_ROW_ALLIANCE_CREATED_ON:
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_ALLIANCE_DESCRIPTION:
			return [LETableViewCellLabeledParagraph getHeightForTableView:tableView text:self.allianceStatus.allianceDescription];
			break;
		case BUILDING_ROW_ALLIANCE_ANNOUNCEMENTS:
			return [LETableViewCellLabeledParagraph getHeightForTableView:tableView text:self.allianceStatus.announcements];
			break;
		default:
			return [super tableView:tableView heightForBuildingRow:buildingRow];
			break;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	UITableViewCell *cell = nil;
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_MY_INVITES:
			; //DO NOT REMOVE
			LETableViewCellButton *myInvitesButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			myInvitesButtonCell.textLabel.text = @"My Invites";
			cell = myInvitesButtonCell;
			break;
		case BUILDING_ROW_CREATE_ALLIANCE:
			; //DO NOT REMOVE
			LETableViewCellButton *createAllianceButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			createAllianceButtonCell.textLabel.text = @"Create Alliance";
			cell = createAllianceButtonCell;
			break;
		case BUILDING_ROW_LEAVE_ALLIANCE:
			; //DO NOT REMOVE
			LETableViewCellButton *leaveAllianceButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			leaveAllianceButtonCell.textLabel.text = @"Leave Alliance";
			cell = leaveAllianceButtonCell;
			break;
		case BUILDING_ROW_CREATE_INVITE:
			; //DO NOT REMOVE
			LETableViewCellButton *inviteNewMemberButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			inviteNewMemberButtonCell.textLabel.text = @"Invite New Member";
			cell = inviteNewMemberButtonCell;
			break;
		case BUILDING_ROW_VIEW_PENDING_INVITES:
			; //DO NOT REMOVE
			LETableViewCellButton *viewPendingInvitesButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			viewPendingInvitesButtonCell.textLabel.text = @"Pending Invites";
			cell = viewPendingInvitesButtonCell;
			break;
		case BUILDING_ROW_UPDATE_ALLIANCE:
			; //DO NOT REMOVE
			LETableViewCellButton *updateAllianceButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			updateAllianceButtonCell.textLabel.text = @"Update Alliance";
			cell = updateAllianceButtonCell;
			break;
		case BUILDING_ROW_DISOLVE_ALLIANCE:
			; //DO NOT REMOVE
			LETableViewCellButton *disolveAllianceButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			disolveAllianceButtonCell.textLabel.text = @"Disolve Alliance";
			cell = disolveAllianceButtonCell;
			break;
		case BUILDING_ROW_ALLIANCE_NAME:
			; //DO NOT REMOVE
			LETableViewCellLabeledText *allianceNameCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			allianceNameCell.label.text = @"Name";
			allianceNameCell.content.text = self.allianceStatus.name;
			cell = allianceNameCell;
			break;
		case BUILDING_ROW_ALLIANCE_LEADER:
			; //DO NOT REMOVE
			LETableViewCellLabeledText *allianceLeaderCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			allianceLeaderCell.label.text = @"Leader";
			allianceLeaderCell.content.text = self.allianceStatus.leaderName;
			cell = allianceLeaderCell;
			break;
		case BUILDING_ROW_ALLIANCE_FORUM:
			; //DO NOT REMOVE
			LETableViewCellLabeledText *allianceForumCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			allianceForumCell.label.text = @"Forum";
			if (isNotNull(self.allianceStatus.forumUri) && [self.allianceStatus.forumUri length]>0) {
				allianceForumCell.content.text = self.allianceStatus.forumUri;
			} else {
				allianceForumCell.content.text = @"empty";
			}

			cell = allianceForumCell;
			break;
		case BUILDING_ROW_ALLIANCE_CREATED_ON:
			; //DO NOT REMOVE
			LETableViewCellLabeledText *allianceCreatedOnCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			allianceCreatedOnCell.label.text = @"Created";
			allianceCreatedOnCell.content.text = [Util formatDate:self.allianceStatus.dateCreated];
			cell = allianceCreatedOnCell;
			break;
		case BUILDING_ROW_ALLIANCE_DESCRIPTION:
			; //DO NOT REMOVE
			LETableViewCellLabeledParagraph *allianceDescriptionCell = [LETableViewCellLabeledParagraph getCellForTableView:tableView];
			allianceDescriptionCell.label.text = @"Description";
			if (isNotNull(self.allianceStatus.allianceDescription)) {
				allianceDescriptionCell.content.text = self.allianceStatus.allianceDescription;
			} else {
				allianceDescriptionCell.content.text = @"empty";
			}
			cell = allianceDescriptionCell;
			break;
		case BUILDING_ROW_ALLIANCE_ANNOUNCEMENTS:
			; //DO NOT REMOVE
			LETableViewCellLabeledParagraph *alliancAnnouncementCell = [LETableViewCellLabeledParagraph getCellForTableView:tableView];
			alliancAnnouncementCell.label.text = @"Announcement";
			if (isNotNull(self.allianceStatus.announcements)) {
				alliancAnnouncementCell.content.text = self.allianceStatus.announcements;
			} else {
				alliancAnnouncementCell.content.text = @"empty";
			}
			cell = alliancAnnouncementCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_MY_INVITES:
			; //DO NOT REMOVE
			ViewMyInvitesController *viewMyInvitesController = [ViewMyInvitesController create];
			viewMyInvitesController.embassy = self;
			return viewMyInvitesController;
		case BUILDING_ROW_CREATE_ALLIANCE:
			; //DO NOT REMOVE
			NewAllianceController *newAllianceController = [NewAllianceController create];
			newAllianceController.embassy = self;
			return newAllianceController;
		case BUILDING_ROW_LEAVE_ALLIANCE:
			; //DO NOT REMOVE
			UIAlertView *av3 = [[[UIAlertView alloc] initWithTitle:@"WIP" message:@"Leave Alliance is not complete yet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
			[av3 show];
			return nil;
		case BUILDING_ROW_CREATE_INVITE:
			; //DO NOT REMOVE
			NewAllianceInvite *newAllianceInvite = [NewAllianceInvite create];
			newAllianceInvite.embassy = self;
			return newAllianceInvite;
		case BUILDING_ROW_VIEW_PENDING_INVITES:
			; //DO NOT REMOVE
			ViewPendingInvitesController *viewPendingInvitesController = [ViewPendingInvitesController create];
			viewPendingInvitesController.embassy = self;
			return viewPendingInvitesController;
		case BUILDING_ROW_UPDATE_ALLIANCE:
			; //DO NOT REMOVE
			UIAlertView *av6 = [[[UIAlertView alloc] initWithTitle:@"WIP" message:@"Update Alliance is not complete yet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
			[av6 show];
			return nil;
		case BUILDING_ROW_DISOLVE_ALLIANCE:
			; //DO NOT REMOVE
			DisolveAllianceController *disolveAllianceController = [DisolveAllianceController create];
			disolveAllianceController.embassy = self;
			return disolveAllianceController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark --
#pragma mark Instance Methods

- (void)acceptInvite:(NSString *)inviteId withMessage:(NSString *)message {
	__block MyAllianceInvite *foundInvite = nil;
	[self.myInvites enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		MyAllianceInvite *invite = obj;
		if ([invite.id isEqualToString:inviteId]) {
			foundInvite = invite;
			*stop = YES;
		}
	}];
	if (foundInvite) {
		[self.myInvites removeObject:foundInvite];
	}
	[[[LEBuildingAcceptInvite alloc] initWithCallback:@selector(inviteAccepted:) target:self buildingId:self.id buildingUrl:self.buildingUrl inviteId:inviteId message:message] autorelease];
}


- (void)assignAllianceLeader:(NSString *)newLeaderId {
	[[[LEBuildingAssignAllianceLeader alloc] initWithCallback:@selector(allianceLeaderAssigned:) target:self buildingId:self.id buildingUrl:self.buildingUrl newLeaderId:newLeaderId] autorelease];
}



- (void)createAllianceWithName:(NSString *)allianceName target:(id)target callback:(SEL)callback{
	self->createAllianceTarget = target;
	self->createAllianceCallback = callback;
	[[[LEBuildingCreateAlliance alloc] initWithCallback:@selector(allianceCreated:) target:self buildingId:self.id buildingUrl:self.buildingUrl name:allianceName] autorelease];
}


- (void)disolveAlliance {
	[[[LEBuildingDissolveAlliance alloc] initWithCallback:@selector(allianceDisolved:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)expelMemeber:(NSString *)empireId withMessage:(NSString *)message {
	[[[LEBuildingExpelMember alloc] initWithCallback:@selector(memeberExpeled:) target:self buildingId:self.id buildingUrl:self.buildingUrl empireId:empireId message:message] autorelease];
}


- (void)loadAllianceStatus {
	[[[LEBuildingGetAllianceStatus alloc] initWithCallback:@selector(allianceStatusLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)loadPendingInvites {
	[[[LEBuildingGetPendingInvites alloc] initWithCallback:@selector(pendingInvitesLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)loadMyInvites {
	[[[LEBuildingGetMyInvites alloc] initWithCallback:@selector(myInvitesLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)leaveAllianceWithMessage:(NSString *)message {
	[[[LEBuildingLeaveAlliance alloc] initWithCallback:@selector(allianceLeft:) target:self buildingId:self.id buildingUrl:self.buildingUrl message:message] autorelease];
}


- (void)rejectInvite:(NSString *)inviteId withMessage:(NSString *)message {
	__block MyAllianceInvite *foundInvite = nil;
	[self.myInvites enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		MyAllianceInvite *invite = obj;
		if ([invite.id isEqualToString:inviteId]) {
			foundInvite = invite;
			*stop = YES;
		}
	}];
	if (foundInvite) {
		[self.myInvites removeObject:foundInvite];
	}
	[[[LEBuildingRejectInvite alloc] initWithCallback:@selector(inviteRejected:) target:self buildingId:self.id buildingUrl:self.buildingUrl inviteId:inviteId message:message] autorelease];
}


- (void)sendInviteTo:(NSString *)inviteeId withMessage:(NSString *)message {
	[[[LEBuildingSendInvite alloc] initWithCallback:@selector(inviteSent:) target:self buildingId:self.id buildingUrl:self.buildingUrl inviteeId:inviteeId message:message] autorelease];
}


- (void)updateAllianceWithForumUri:(NSString *)forumUri description:(NSString *)description announcements:(NSString *)announcements {
	[[[LEBuildingUpdateAlliance alloc] initWithCallback:@selector(allianceUpdated:) target:self buildingId:self.id buildingUrl:self.buildingUrl forumUri:forumUri description:description announcements:announcements] autorelease];
}


- (void)withdrawInvite:(NSString *)inviteId withMessage:(NSString *)message {
	__block PendingAllianceInvite *foundInvite = nil;
	[self.pendingInvites enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		PendingAllianceInvite *invite = obj;
		if ([invite.id isEqualToString:inviteId]) {
			foundInvite = invite;
			*stop = YES;
		}
	}];
	if (foundInvite) {
		[self.pendingInvites removeObject:foundInvite];
	}
	[[[LEBuildingWithdrawInvite alloc] initWithCallback:@selector(inviteWithdrawn:) target:self buildingId:self.id buildingUrl:self.buildingUrl inviteId:inviteId message:message] autorelease];	
}


#pragma mark --
#pragma mark Callback Methods

- (void)inviteAccepted:(LEBuildingAcceptInvite *)request {
	[self.allianceStatus parseData:request.allianceStatus];
}


- (void)allianceLeaderAssigned:(LEBuildingAssignAllianceLeader *)request {
	[self.allianceStatus parseData:request.allianceStatus];
}


- (void)allianceCreated:(LEBuildingCreateAlliance *)request {
	[self.allianceStatus parseData:request.allianceStatus];
	[self->createAllianceTarget performSelector:self->createAllianceCallback withObject:request];
}


- (void)allianceDisolved:(LEBuildingDissolveAlliance *)request {
	self.allianceStatus = nil;
	self.needsRefresh = YES;
}


- (void)memeberExpeled:(LEBuildingExpelMember *)request {
	[self.allianceStatus parseData:request.allianceStatus];
}


- (void)allianceStatusLoaded:(LEBuildingGetAllianceStatus *)request {
	[self.allianceStatus parseData:request.allianceStatus];
}


- (void)pendingInvitesLoaded:(LEBuildingGetPendingInvites *)request {
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[request.invites count]];
	for (NSMutableDictionary *pendingInviteData in request.invites) {
		PendingAllianceInvite *invite = [[[PendingAllianceInvite alloc] init] autorelease];
		[invite parseData:pendingInviteData];
		[tmp addObject:invite];
	}
	self.pendingInvites = tmp;
}


- (void)myInvitesLoaded:(LEBuildingGetMyInvites *)request {
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[request.invites count]];
	for (NSMutableDictionary *myInviteData in request.invites) {
		MyAllianceInvite *invite = [[[MyAllianceInvite alloc] init] autorelease];
		[invite parseData:myInviteData];
		[tmp addObject:invite];
	}
	self.myInvites = tmp;
}


- (void)allianceLeft:(LEBuildingLeaveAlliance *)request {
	//Do we need to do anything?
}


- (void)inviteRejected:(LEBuildingRejectInvite *)request {
	//Do we need to do anything?
}


- (void)inviteSent:(LEBuildingSendInvite *)request {
	//Do we need to do anything?
}


- (void)allianceUpdated:(LEBuildingUpdateAlliance *)request {
	[self.allianceStatus parseData:request.allianceStatus];
}


- (void)inviteWithdrawn:(LEBuildingWithdrawInvite *)request {
	//Do we need to do anything?
}


@end
