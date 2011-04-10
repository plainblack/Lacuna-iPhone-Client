//
//  Parliament.h
//  UniversalClient
//
//  Created by Kevin Runde on 3/21/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Module.h"


@class Law;
@class MiningPlatform;


@interface Parliament : Module {
}


@property (nonatomic, retain) NSMutableArray *propositions;
@property (nonatomic, retain) NSMutableArray *laws;
@property (nonatomic, retain) NSMutableArray *starsInJurisdiction;
@property (nonatomic, retain) id castVoteTarget;
@property (nonatomic, assign) SEL castVoteCallback;
@property (nonatomic, retain) id repealLawTarget;
@property (nonatomic, assign) SEL repealLawCallback;
@property (nonatomic, retain) id proposeWritTarget;
@property (nonatomic, assign) SEL proposeWritCallback;
@property (nonatomic, retain) id proposeTransferStationOwnershipTarget;
@property (nonatomic, assign) SEL proposeTransferStationOwnershipCallback;
@property (nonatomic, retain) id proposeSeizeStarTarget;
@property (nonatomic, assign) SEL proposeSeizeStarCallback;
@property (nonatomic, retain) id proposeRenameStarTarget;
@property (nonatomic, assign) SEL proposeRenameStarCallback;
@property (nonatomic, retain) id proposeBroadcastOnNetwork19Target;
@property (nonatomic, assign) SEL proposeBroadcastOnNetwork19Callback;
@property (nonatomic, retain) id proposeInductMemberTarget;
@property (nonatomic, assign) SEL proposeInductMemberCallback;
@property (nonatomic, retain) id proposeExpelMemberTarget;
@property (nonatomic, assign) SEL proposeExpelMemberCallback;
@property (nonatomic, retain) id proposeElectNewLeaderTarget;
@property (nonatomic, assign) SEL proposeElectNewLeaderCallback;
@property (nonatomic, retain) id proposeRenameAsteroidTarget;
@property (nonatomic, assign) SEL proposeRenameAsteroidCallback;
@property (nonatomic, retain) id proposeRenameUninhabitedTarget;
@property (nonatomic, assign) SEL proposeRenameUninhabitedCallback;
@property (nonatomic, retain) id proposeMembersOnlyMiningRightsTarget;
@property (nonatomic, assign) SEL proposeMembersOnlyMiningRightsCallback;
@property (nonatomic, retain) id proposeEvictMiningPlatformTarget;
@property (nonatomic, assign) SEL proposeEvictMiningPlatformCallback;
@property (nonatomic, retain) id proposeTaxationTarget;
@property (nonatomic, assign) SEL proposeTaxationCallback;
@property (nonatomic, retain) id proposeForeignAidTarget;
@property (nonatomic, assign) SEL proposeForeignAidCallback;
@property (nonatomic, retain) id proposeMembersOnlyColonizationTarget;
@property (nonatomic, assign) SEL proposeMembersOnlyColonizationCallback;
@property (nonatomic, retain) id proposeFireBfgTarget;
@property (nonatomic, assign) SEL proposeFireBfgCallback;


- (void)loadPropositions;
- (void)loadLawsForStationId:(NSString *)stationId;
- (void)loadStarsInJurisdiction;
- (void)castVote:(BOOL)vote propositionId:(NSString *)propositionId target:(id)target callback:(SEL)callback;
- (void)repealLaw:(Law *)law target:(id)target callback:(SEL)callback;
- (void)proposeWritTitle:(NSString *)title description:(NSString *)description target:(id)target callback:(SEL)callback;
- (void)proposeTransferStationOwnershipTo:(NSString *)empireId target:(id)target callback:(SEL)callback;
- (void)proposeSeizeStar:(NSString *)starId target:(id)target callback:(SEL)callback;
- (void)proposeRenameStar:(NSString *)starId name:(NSString *)name target:(id)target callback:(SEL)callback;
- (void)proposeBroadcastOnNetwork19:(NSString *)message target:(id)target callback:(SEL)callback;
- (void)proposeInductMember:(NSString *)empireId message:(NSString *)message target:(id)target callback:(SEL)callback;
- (void)proposeExpelMember:(NSString *)empireId message:(NSString *)message target:(id)target callback:(SEL)callback;
- (void)proposeElectNewLeader:(NSString *)empireId target:(id)target callback:(SEL)callback;
- (void)proposeRenameAsteroid:(NSString *)asteroidId name:(NSString *)name target:(id)target callback:(SEL)callback;
- (void)proposeRenameUninhabited:(NSString *)bodyId name:(NSString *)name target:(id)target callback:(SEL)callback;
- (void)proposeMembersOnlyMiningRightsTarget:(id)target callback:(SEL)callback;
- (void)proposeEvictMiningPlatform:(MiningPlatform *)miningPlatform target:(id)target callback:(SEL)callback;
- (void)proposeTaxation:(NSDecimalNumber *)amount target:(id)target callback:(SEL)callback;
- (void)proposeForeignAidTo:(NSString *)bodyId amount:(NSDecimalNumber *)amount target:(id)target callback:(SEL)callback;
- (void)proposeMembersOnlyColonizationTarget:(id)target callback:(SEL)callback;
- (void)proposeFireBfgOn:(NSString *)bodyId reason:(NSString *)reason target:(id)target callback:(SEL)callback;


@end
