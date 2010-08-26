//
//  Embassy.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/23/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@class AllianceStatus;


@interface Embassy : Building {
	AllianceStatus *allianceStatus;
	NSMutableArray *myInvites;
	NSMutableArray *pendingInvites;
	id createAllianceTarget;
	SEL createAllianceCallback;
}


@property (nonatomic, retain) AllianceStatus *allianceStatus;
@property (nonatomic, retain) NSMutableArray *myInvites;
@property (nonatomic, retain) NSMutableArray *pendingInvites;


- (void)acceptInvite:(NSString *)inviteId withMessage:(NSString *)message;
- (void)assignAllianceLeader:(NSString *)newLeaderId;
- (void)createAllianceWithName:(NSString *)name target:(id)target callback:(SEL)callback;
- (void)disolveAlliance;
- (void)expelMemeber:(NSString *)empireId withMessage:(NSString *)message;
- (void)getAllianceStatus;
- (void)getPendingInvites;
- (void)getMyInvites;
- (void)leaveAllianceWithMessage:(NSString *)message;
- (void)rejectInvite:(NSString *)inviteId withMessage:(NSString *)message;
- (void)sendInviteTo:(NSString *)inviteeId withMessage:(NSString *)message;
- (void)updateAllianceWithForumUri:(NSString *)forumUri description:(NSString *)description announcements:(NSString *)announcements;
- (void)withdrawInvite:(NSString *)inviteId withMessage:(NSString *)message;


@end
