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
#import "LeaveAllianceController.h"
#import "ViewAllianceMembersController.h"
#import "EditTextViewController.h"
#import "EditTextFieldController.h"
#import "LEBuildingViewStash.h"
#import	"LEBuildingDonateToStash.h"
#import "LEBuildingExchangeWithStash.h"
#import "ViewAllianceStashController.h"


@implementation Embassy


@synthesize allianceStatus;
@synthesize pendingInvites;
@synthesize myInvites;
@synthesize stash;
@synthesize storedResources;
@synthesize maxExchangeSize;
@synthesize exchangesRemainingToday;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.allianceStatus = nil;
	self.pendingInvites = nil;
	self.myInvites = nil;
	self.stash = nil;
	self.storedResources = nil;
	self.maxExchangeSize = nil;
	self.exchangesRemainingToday = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Overriden Building Methods

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
			[tmp addObject:_dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_STASH], [NSDecimalNumber numberWithInt:BUILDING_ROW_ALLIANCE_MEMBERS], [NSDecimalNumber numberWithInt:BUILDING_ROW_CREATE_INVITE], [NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_PENDING_INVITES], [NSDecimalNumber numberWithInt:BUILDING_ROW_UPDATE_ALLIANCE], [NSDecimalNumber numberWithInt:BUILDING_ROW_DISOLVE_ALLIANCE], [NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_MY_INVITES]), @"rows")];
		} else {
			[tmp addObject:_dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_STASH], [NSDecimalNumber numberWithInt:BUILDING_ROW_LEAVE_ALLIANCE], [NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_MY_INVITES]), @"rows")];
		}
	} else {
		[tmp addObject:_dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_MY_INVITES], [NSDecimalNumber numberWithInt:BUILDING_ROW_CREATE_ALLIANCE]), @"rows")];
	}
	
	[tmp addObject:[self generateHealthSection]];
	[tmp addObject:[self generateUpgradeSection]];
	[tmp addObject:[self generateGeneralInfoSection]];
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
		case BUILDING_ROW_ALLIANCE_MEMBERS:
		case BUILDING_ROW_VIEW_STASH:
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
	Session *session = [Session sharedInstance];
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
		case BUILDING_ROW_ALLIANCE_MEMBERS:
			; //DO NOT REMOVE
			LETableViewCellButton *viewAllianceMembersButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			viewAllianceMembersButtonCell.textLabel.text = @"View Members";
			cell = viewAllianceMembersButtonCell;
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
			LETableViewCellLabeledText *allianceForumCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:YES];
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
			if ([session.empire.id isEqualToString:self.allianceStatus.leaderId]) {
				allianceDescriptionCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				allianceDescriptionCell.selectionStyle = UITableViewCellSelectionStyleBlue;
			} else {
				allianceDescriptionCell.accessoryType = UITableViewCellAccessoryNone;
				allianceDescriptionCell.selectionStyle = UITableViewCellSelectionStyleNone;
			}

			cell = allianceDescriptionCell;
			break;
		case BUILDING_ROW_ALLIANCE_ANNOUNCEMENTS:
			; //DO NOT REMOVE
			LETableViewCellLabeledParagraph *allianceAnnouncementCell = [LETableViewCellLabeledParagraph getCellForTableView:tableView];
			allianceAnnouncementCell.label.text = @"Announcement";
			if (isNotNull(self.allianceStatus.announcements)) {
				allianceAnnouncementCell.content.text = self.allianceStatus.announcements;
			} else {
				allianceAnnouncementCell.content.text = @"empty";
			}
			if ([session.empire.id isEqualToString:self.allianceStatus.leaderId]) {
				allianceAnnouncementCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				allianceAnnouncementCell.selectionStyle = UITableViewCellSelectionStyleBlue;
			} else {
				allianceAnnouncementCell.accessoryType = UITableViewCellAccessoryNone;
				allianceAnnouncementCell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			cell = allianceAnnouncementCell;
			break;
		case BUILDING_ROW_VIEW_STASH:
			; //DO NOT REMOVE
			LETableViewCellButton *vieStashButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			vieStashButtonCell.textLabel.text = @"View Stash";
			cell = vieStashButtonCell;
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
			LeaveAllianceController *leaveAllianceController = [LeaveAllianceController create];
			leaveAllianceController.embassy = self;
			return leaveAllianceController;
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
			UIAlertController *av6 = [UIAlertController alertControllerWithTitle:@"WIP" message: @"Update Alliance is not complete yet" preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
								 { [av6 dismissViewControllerAnimated:YES completion:nil]; }];
			[av6 addAction: ok];
			return nil;
		case BUILDING_ROW_DISOLVE_ALLIANCE:
			; //DO NOT REMOVE
			DisolveAllianceController *disolveAllianceController = [DisolveAllianceController create];
			disolveAllianceController.embassy = self;
			return disolveAllianceController;
			break;
		case BUILDING_ROW_ALLIANCE_MEMBERS:
			; //DO NOT REMOVE
			ViewAllianceMembersController *viewAllianceMembersController = [ViewAllianceMembersController create];
			viewAllianceMembersController.embassy = self;
			return viewAllianceMembersController;
			break;
		case BUILDING_ROW_ALLIANCE_FORUM:
			; //DO NOT REMOVE
			EditTextFieldController *editTextFieldController = [EditTextFieldController createForTextName:@"Forum URI" textValue:self.allianceStatus.forumUri];
			editTextFieldController.delegate = self;
			return editTextFieldController;
			break;
		case BUILDING_ROW_ALLIANCE_DESCRIPTION:
			; //DO NOT REMOVE
			EditTextViewController *editTextViewController1 = [EditTextViewController createForTextName:@"Description" textValue:self.allianceStatus.allianceDescription];
			editTextViewController1.delegate = self;
			return editTextViewController1;
			break;
		case BUILDING_ROW_ALLIANCE_ANNOUNCEMENTS:
			; //DO NOT REMOVE
			EditTextViewController *editTextViewController2 = [EditTextViewController createForTextName:@"Announcements" textValue:self.allianceStatus.announcements];
			editTextViewController2.delegate = self;
			return editTextViewController2;
			break;
		case BUILDING_ROW_VIEW_STASH:
			; //DO NOT REMOVE
			ViewAllianceStashController *viewAllianceStashController = [ViewAllianceStashController create];
			viewAllianceStashController.embassy = self;
			return viewAllianceStashController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark -
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


- (void)assignAllianceLeader:(NSString *)leaderId {
	[[[LEBuildingAssignAllianceLeader alloc] initWithCallback:@selector(allianceLeaderAssigned:) target:self buildingId:self.id buildingUrl:self.buildingUrl newLeaderId:leaderId] autorelease];
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
	self.allianceStatus = nil;
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
	if(forumUri) {
		self.allianceStatus.forumUri = forumUri;
	}
	if(description) {
		self.allianceStatus.allianceDescription = description;
	}
	if(announcements) {
		self.allianceStatus.announcements = announcements;
	}
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


- (void)getStashTarget:(id)target callback:(SEL)callback {
	self->getStashTarget = target;
	self->getStashCallback = callback;
	[[[LEBuildingViewStash alloc] initWithCallback:@selector(stashLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)donateToStash:(NSMutableDictionary *)donation target:(id)target callback:(SEL)callback {
	self->donateToStashTarget = target;
	self->donateToStashCallback = callback;
	[[[LEBuildingDonateToStash alloc] initWithCallback:@selector(donatedToStash:) target:self buildingId:self.id buildingUrl:self.buildingUrl donation:donation] autorelease];
}


- (void)stashExchangeDonation:(NSMutableDictionary *)donation request:(NSMutableDictionary *)request target:(id)target callback:(SEL)callback {
	self->exchangeWithStashTarget = target;
	self->exchangeWithStashCallback = callback;
	[[[LEBuildingExchangeWithStash alloc] initWithCallback:@selector(exchangedWithStash:) target:self buildingId:self.id buildingUrl:self.buildingUrl donation:donation request:request] autorelease];
}


#pragma mark -
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



- (void)stashLoaded:(LEBuildingViewStash *) request {
	self.stash = [NSMutableDictionary dictionaryWithCapacity:[request.stash count]];
	[request.stash enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
		NSDecimalNumber *amount = [Util asNumber:obj];
		if (![amount isEqual:[NSDecimalNumber zero]]) {
			[self.stash setObject:amount forKey:key];
		}
	}];
	NSLog(@"Request Stash: %@", request.stash);
	NSLog(@"Parsed Stash: %@", self.stash);
	self.storedResources = [NSMutableDictionary dictionaryWithCapacity:[request.stored count]];
	[request.stored enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
		NSDecimalNumber *amount = [Util asNumber:obj];
		[self.storedResources setObject:amount forKey:key];
	}];
	self.maxExchangeSize = request.maxExchangeSize;
	self.exchangesRemainingToday = request.exchangesRemainingToday;
	[self->getStashTarget performSelector:self->getStashCallback];
}


- (void)donatedToStash:(LEBuildingDonateToStash *) request {
	self.stash = [NSMutableDictionary dictionaryWithCapacity:[request.stash count]];
	[request.stash enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
		NSDecimalNumber *amount = [Util asNumber:obj];
		if (![amount isEqual:[NSDecimalNumber zero]]) {
			[self.stash setObject:amount forKey:key];
		}
	}];
	self.storedResources = [NSMutableDictionary dictionaryWithCapacity:[request.stored count]];
	[request.stored enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
		NSDecimalNumber *amount = [Util asNumber:obj];
		[self.storedResources setObject:amount forKey:key];
	}];
	self.maxExchangeSize = request.maxExchangeSize;
	self.exchangesRemainingToday = request.exchangesRemainingToday;
	[self->donateToStashTarget performSelector:self->donateToStashCallback withObject:request];
}


- (void)exchangedWithStash:(LEBuildingExchangeWithStash *) request {
	self.stash = [NSMutableDictionary dictionaryWithCapacity:[request.stash count]];
	[request.stash enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
		NSDecimalNumber *amount = [Util asNumber:obj];
		if (![amount isEqual:[NSDecimalNumber zero]]) {
			[self.stash setObject:amount forKey:key];
		}
	}];
	self.storedResources = [NSMutableDictionary dictionaryWithCapacity:[request.stored count]];
	[request.stored enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
		NSDecimalNumber *amount = [Util asNumber:obj];
		[self.storedResources setObject:amount forKey:key];
	}];
	self.maxExchangeSize = request.maxExchangeSize;
	self.exchangesRemainingToday = request.exchangesRemainingToday;
	[self->exchangeWithStashTarget performSelector:self->exchangeWithStashCallback withObject:request];
}


#pragma mark -
#pragma mark EditTextViewControllerDelegate Methods

- (BOOL)newTextValue:(NSString *)value forTextName:(NSString *)textName {
	if ([textName isEqualToString:@"Description"]) {
		[self updateAllianceWithForumUri:nil description:value announcements:nil];
	} else if ([textName isEqualToString:@"Announcements"]) {
		[self updateAllianceWithForumUri:nil description:nil announcements:value];
	}
	return YES;
}


#pragma mark -
#pragma mark EditTextFieldControllerDelegate Methods

- (BOOL)newTextEntryValue:(NSString *)value forTextName:(NSString *)textName {
	if ([textName isEqualToString:@"Forum URI"]) {
		[self updateAllianceWithForumUri:value description:nil announcements:nil];
	}
	return YES;
}


@end
