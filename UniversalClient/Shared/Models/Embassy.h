//
//  Embassy.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/23/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"
#import "EditTextViewController.h"
#import "EditTextFieldController.h"


@class AllianceStatus;


@interface Embassy : Building <EditTextViewControllerDelegate, EditTextFieldControllerDelegate> {
	id createAllianceTarget;
	SEL createAllianceCallback;
	id getStashTarget;
	SEL getStashCallback;
	id donateToStashTarget;
	SEL donateToStashCallback;
	id exchangeWithStashTarget;
	SEL exchangeWithStashCallback;
}


@property (nonatomic, retain) AllianceStatus *allianceStatus;
@property (nonatomic, retain) NSMutableArray *myInvites;
@property (nonatomic, retain) NSMutableArray *pendingInvites;
@property (nonatomic, retain) NSMutableDictionary *stash;
@property (nonatomic, retain) NSMutableDictionary *storedResources;
@property (nonatomic, retain) NSDecimalNumber *maxExchangeSize;
@property (nonatomic, retain) NSDecimalNumber *exchangesRemainingToday;


- (void)acceptInvite:(NSString *)inviteId withMessage:(NSString *)message;
- (void)assignAllianceLeader:(NSString *)newLeaderId;
- (void)createAllianceWithName:(NSString *)name target:(id)target callback:(SEL)callback;
- (void)disolveAlliance;
- (void)expelMemeber:(NSString *)empireId withMessage:(NSString *)message;
- (void)loadAllianceStatus;
- (void)loadPendingInvites;
- (void)loadMyInvites;
- (void)leaveAllianceWithMessage:(NSString *)message;
- (void)rejectInvite:(NSString *)inviteId withMessage:(NSString *)message;
- (void)sendInviteTo:(NSString *)inviteeId withMessage:(NSString *)message;
- (void)updateAllianceWithForumUri:(NSString *)forumUri description:(NSString *)description announcements:(NSString *)announcements;
- (void)withdrawInvite:(NSString *)inviteId withMessage:(NSString *)message;
- (void)getStashTarget:(id)target callback:(SEL)callback;
- (void)donateToStash:(NSMutableDictionary *)donation target:(id)target callback:(SEL)callback;
- (void)stashExchangeDonation:(NSMutableDictionary *)donation request:(NSMutableDictionary *)request target:(id)target callback:(SEL)callback;


@end
