//
//  Parliament.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/21/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "Parliament.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "LETableViewCellButton.h"
#import "LEBuildingViewPropositions.h"
#import "LEBuildingViewLaws.h"
#import "LEBuildingCastVote.h"
#import "LEBuildingProposeRepealLaw.h"
#import "LEBuildingProposeWrit.h"
#import "LEBuildingProposeTransferStationOwnership.h"
#import "LEBuildingProposeSeizeStar.h"
#import "LEBuildingProposeRenameStar.h"
#import "LEBuildingProposeBroadcastOnNetwork19.h"
#import "LEBuildingProposeInductMember.h"
#import "LEBuildingProposeExpelMember.h"
#import "LEBuildingProposeElectNewLeader.h"
#import "LEBuildingProposeRenameAsteroid.h"
#import "LEBuildingProposeRenameUninhabited.h"
#import "LEBuildingProposeMembersOnlyMiningRights.h"
#import "LEBuildingProposeEvictMiningPlatform.h"
#import "LEBuildingProposeTaxation.h"
#import "LEBuildingProposeForeignAid.h"
#import "LEBuildingProposeMembersOnlyColonization.h"
#import "LEBuildingProposeFireBfg.h"
#import "LEBuildingViewTaxesCollected.h"
#import "LEBuildingGetStarsInJurisdiction.h"
#import "LEBuildingGetBodiesForStarInJurisdiction.h"
#import "LEBuidingGetMiningPlatformsForAsteroidInJurisdiction.h"
#import "Proposition.h"
#import "Law.h"
#import "MiningPlatform.h"
#import "ViewPropositionsController.h"
#import "ViewLawsController.h"
#import "ChooseProposeTypeViewController.h"


@interface Parliament(PrivateMethods)


- (NSMutableArray *)parsePropositions:(NSMutableArray *)propositions;
- (NSMutableArray *)parseLaws:(NSMutableArray *)propositions;


@end


@implementation Parliament


@synthesize propositions;
@synthesize laws;
@synthesize starsInJurisdiction;
@synthesize castVoteTarget;
@synthesize castVoteCallback;
@synthesize repealLawTarget;
@synthesize repealLawCallback;
@synthesize proposeWritTarget;
@synthesize proposeWritCallback;
@synthesize proposeTransferStationOwnershipTarget;
@synthesize proposeTransferStationOwnershipCallback;
@synthesize proposeSeizeStarTarget;
@synthesize proposeSeizeStarCallback;
@synthesize proposeRenameStarTarget;
@synthesize proposeRenameStarCallback;
@synthesize proposeBroadcastOnNetwork19Target;
@synthesize proposeBroadcastOnNetwork19Callback;
@synthesize proposeInductMemberTarget;
@synthesize proposeInductMemberCallback;
@synthesize proposeExpelMemberTarget;
@synthesize proposeExpelMemberCallback;
@synthesize proposeElectNewLeaderTarget;
@synthesize proposeElectNewLeaderCallback;
@synthesize proposeRenameAsteroidTarget;
@synthesize proposeRenameAsteroidCallback;
@synthesize proposeRenameUninhabitedTarget;
@synthesize proposeRenameUninhabitedCallback;
@synthesize proposeMembersOnlyMiningRightsTarget;
@synthesize proposeMembersOnlyMiningRightsCallback;
@synthesize proposeEvictMiningPlatformTarget;
@synthesize proposeEvictMiningPlatformCallback;
@synthesize proposeTaxationTarget;
@synthesize proposeTaxationCallback;
@synthesize proposeForeignAidTarget;
@synthesize proposeForeignAidCallback;
@synthesize proposeMembersOnlyColonizationTarget;
@synthesize proposeMembersOnlyColonizationCallback;
@synthesize proposeFireBfgTarget;
@synthesize proposeFireBfgCallback;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
    self.propositions = nil;
    self.laws = nil;
    self.starsInJurisdiction = nil;
    self.castVoteTarget = nil;
    self.castVoteCallback = nil;
    self.repealLawTarget = nil;
    self.repealLawCallback = nil;
    self.proposeWritTarget = nil;
    self.proposeWritCallback = nil;
    self.proposeTransferStationOwnershipTarget = nil;
    self.proposeTransferStationOwnershipCallback = nil;
    self.proposeSeizeStarTarget = nil;
    self.proposeSeizeStarCallback = nil;
    self.proposeRenameStarTarget = nil;
    self.proposeRenameStarCallback = nil;
    self.proposeBroadcastOnNetwork19Target = nil;
    self.proposeBroadcastOnNetwork19Callback = nil;
    self.proposeInductMemberTarget = nil;
    self.proposeInductMemberCallback = nil;
    self.proposeExpelMemberTarget = nil;
    self.proposeExpelMemberCallback = nil;
    self.proposeElectNewLeaderTarget = nil;
    self.proposeElectNewLeaderCallback = nil;
    self.proposeRenameAsteroidTarget = nil;
    self.proposeRenameAsteroidCallback = nil;
    self.proposeRenameUninhabitedTarget = nil;
    self.proposeRenameUninhabitedCallback = nil;
    self.proposeMembersOnlyMiningRightsTarget = nil;
    self.proposeMembersOnlyMiningRightsCallback = nil;
    self.proposeEvictMiningPlatformTarget = nil;
    self.proposeEvictMiningPlatformCallback = nil;
    self.proposeTaxationTarget = nil;
    self.proposeTaxationCallback = nil;
    self.proposeForeignAidTarget = nil;
    self.proposeForeignAidCallback = nil;
    self.proposeMembersOnlyColonizationTarget = nil;
    self.proposeMembersOnlyColonizationCallback = nil;
    self.proposeFireBfgTarget = nil;
    self.proposeFireBfgCallback = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Overriden Building Methods

- (void)generateSections {
    NSMutableArray *actionRows = _array([NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_PROPOSITIONS], [NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_LAWS], [NSDecimalNumber numberWithInt:BUILDING_ROW_PROPOSE]);
	NSMutableDictionary *actionSection = _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", actionRows, @"rows");
    
	self.sections = _array([self generateProductionSection], actionSection, [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_PROPOSITIONS:
		case BUILDING_ROW_VIEW_LAWS:
		case BUILDING_ROW_PROPOSE:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		default:
			return [super tableView:tableView heightForBuildingRow:buildingRow];
			break;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	UITableViewCell *cell = nil;
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_PROPOSITIONS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *viewPropositionsCell = [LETableViewCellButton getCellForTableView:tableView];
			viewPropositionsCell.textLabel.text = @"View Propositions";
			cell = viewPropositionsCell;
			break;
		case BUILDING_ROW_VIEW_LAWS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *viewLawsCell = [LETableViewCellButton getCellForTableView:tableView];
			viewLawsCell.textLabel.text = @"View Laws";
			cell = viewLawsCell;
			break;
		case BUILDING_ROW_PROPOSE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *proposeWritCell = [LETableViewCellButton getCellForTableView:tableView];
			proposeWritCell.textLabel.text = @"Propose";
			cell = proposeWritCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_PROPOSITIONS:
			; //DO NOT REMOVE
			ViewPropositionsController *viewPropositionsController = [ViewPropositionsController create];
			viewPropositionsController.parliament = self;
			return viewPropositionsController;
			break;
		case BUILDING_ROW_VIEW_LAWS:
			; //DO NOT REMOVE
			ViewLawsController *viewLawsController = [ViewLawsController create];
			viewLawsController.parliament = self;
			return viewLawsController;
			break;
		case BUILDING_ROW_PROPOSE:
			; //DO NOT REMOVE
			ChooseProposeTypeViewController *chooseProposeTypeViewController = [ChooseProposeTypeViewController create];
			chooseProposeTypeViewController.parliament = self;
			return chooseProposeTypeViewController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark -
#pragma mark Instance Methods

- (void)loadPropositions {
    [[[LEBuildingViewPropositions alloc] initWithCallback:@selector(loadedPropositions:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)loadLawsForStationId:(NSString *)stationId {
    [[[LEBuildingViewLaws alloc] initWithCallback:@selector(loadedLaws:) target:self stationId:stationId buildingUrl:self.buildingUrl] autorelease];
}


- (void)loadStarsInJurisdiction {
    [[[LEBuildingGetStarsInJurisdiction alloc] initWithCallback:@selector(loadedStarsInJurisdiction:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)castVote:(BOOL)vote propositionId:(NSString *)propositionId target:(id)target callback:(SEL)callback {
    self.castVoteTarget = target;
    self.castVoteCallback = callback;
    [[[LEBuildingCastVote alloc] initWithCallback:@selector(voted:) target:self buildingId:self.id buildingUrl:self.buildingUrl propositionId:propositionId vote:vote] autorelease];
}


- (void)repealLaw:(Law *)law target:(id)target callback:(SEL)callback {
    self.repealLawTarget = target;
    self.repealLawCallback = callback;
    [[[LEBuildingProposeRepealLaw alloc] initWithCallback:@selector(proposedRepealLaw:) target:self buildingId:self.id buildingUrl:self.buildingUrl lawId:law.id] autorelease];
}


- (void)proposeWritTitle:(NSString *)title description:(NSString *)description target:(id)target callback:(SEL)callback {
    self.proposeWritTarget = target;
    self.proposeWritCallback = callback;
    [[[LEBuildingProposeWrit alloc] initWithCallback:@selector(proposedWrit:) target:self buildingId:self.id buildingUrl:self.buildingUrl title:title description:description] autorelease];
}


- (void)proposeTransferStationOwnershipTo:(NSString *)empireId target:(id)target callback:(SEL)callback {
    self.proposeTransferStationOwnershipTarget = target;
    self.proposeTransferStationOwnershipCallback = callback;
    [[[LEBuildingProposeTransferStationOwnership alloc] initWithCallback:@selector(proposedTransferStationOwnership:) target:self buildingId:self.id buildingUrl:self.buildingUrl toEmpireId:empireId] autorelease];
}


- (void)proposeSeizeStar:(NSString *)starId target:(id)target callback:(SEL)callback {
    self.proposeSeizeStarTarget = target;
    self.proposeSeizeStarCallback = callback;
    [[[LEBuildingProposeSeizeStar alloc] initWithCallback:@selector(proposedSeizeStar:) target:self buildingId:self.id buildingUrl:self.buildingUrl starId:starId] autorelease];
}


- (void)proposeRenameStar:(NSString *)starId name:(NSString *)name target:(id)target callback:(SEL)callback {
    self.proposeRenameStarTarget = target;
    self.proposeRenameStarCallback = callback;
    [[[LEBuildingProposeRenameStar alloc] initWithCallback:@selector(proposedRenameStar:) target:self buildingId:self.id buildingUrl:self.buildingUrl starId:starId name:name] autorelease];
}


- (void)proposeBroadcastOnNetwork19:(NSString *)message target:(id)target callback:(SEL)callback {
    self.proposeBroadcastOnNetwork19Target = target;
    self.proposeBroadcastOnNetwork19Callback = callback;
    [[[LEBuildingProposeBroadcastOnNetwork19 alloc] initWithCallback:@selector(proposedBroadcastOnNetwork19:) target:self buildingId:self.id buildingUrl:self.buildingUrl message:message] autorelease];
}


- (void)proposeInductMember:(NSString *)empireId message:(NSString *)message target:(id)target callback:(SEL)callback {
    self.proposeInductMemberTarget = target;
    self.proposeInductMemberCallback = callback;
    [[[LEBuildingProposeInductMember alloc] initWithCallback:@selector(proposedInductMember:) target:self buildingId:self.id buildingUrl:self.buildingUrl empireId:empireId message:message] autorelease];
}


- (void)proposeExpelMember:(NSString *)empireId message:(NSString *)message target:(id)target callback:(SEL)callback {
    self.proposeExpelMemberTarget = target;
    self.proposeExpelMemberCallback = callback;
    [[[LEBuildingProposeExpelMember alloc]initWithCallback:@selector(proposedExpelMember:) target:self buildingId:self.id buildingUrl:self.buildingUrl empireId:empireId message:message] autorelease];
}


- (void)proposeElectNewLeader:(NSString *)empireId target:(id)target callback:(SEL)callback {
    self.proposeElectNewLeaderTarget = target;
    self.proposeElectNewLeaderCallback = callback;
    [[[LEBuildingProposeElectNewLeader alloc] initWithCallback:@selector(proposedElectNewLeader:) target:self buildingId:self.id buildingUrl:self.buildingUrl empireId:empireId] autorelease];
}


- (void)proposeRenameAsteroid:(NSString *)asteroidId name:(NSString *)name target:(id)target callback:(SEL)callback {
    self.proposeRenameAsteroidTarget = target;
    self.proposeRenameAsteroidCallback = callback;
    [[[LEBuildingProposeRenameAsteroid alloc] initWithCallback:@selector(proposedRenameAsteroid:) target:self buildingId:self.id buildingUrl:self.buildingUrl asteroidId:asteroidId name:name] autorelease];
}


- (void)proposeRenameUninhabited:(NSString *)bodyId name:(NSString *)name target:(id)target callback:(SEL)callback {
    self.proposeRenameUninhabitedTarget = target;
    self.proposeRenameUninhabitedCallback = callback;
    [[[LEBuildingProposeRenameUninhabited alloc] initWithCallback:@selector(proposedRenameUninhabited:) target:self buildingId:self.id buildingUrl:self.buildingUrl planetId:bodyId name:name] autorelease];
}


- (void)proposeMembersOnlyMiningRightsTarget:(id)target callback:(SEL)callback {
    self.proposeMembersOnlyMiningRightsTarget = target;
    self.proposeMembersOnlyMiningRightsCallback = callback;
    [[[LEBuildingProposeMembersOnlyMiningRights alloc] initWithCallback:@selector(proposedMembersOnlyMiningRights:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)proposeEvictMiningPlatform:(MiningPlatform *)miningPlatform target:(id)target callback:(SEL)callback {
    self.proposeEvictMiningPlatformTarget = target;
    self.proposeEvictMiningPlatformCallback = callback;
    [[[LEBuildingProposeEvictMiningPlatform alloc] initWithCallback:@selector(proposedEvictMiningPlatform:) target:self buildingId:self.id buildingUrl:self.buildingUrl miningPlatformId:miningPlatform.id] autorelease];
}


- (void)proposeTaxation:(NSDecimalNumber *)amount target:(id)target callback:(SEL)callback {
    self.proposeTaxationTarget = target;
    self.proposeTaxationCallback = callback;
    [[[LEBuildingProposeTaxation alloc] initWithCallback:@selector(proposedTaxation:) target:self buildingId:self.id buildingUrl:self.buildingUrl taxAmount:amount] autorelease];
}


- (void)proposeForeignAidTo:(NSString *)bodyId amount:(NSDecimalNumber *)amount target:(id)target callback:(SEL)callback {
    self.proposeForeignAidTarget = target;
    self.proposeForeignAidCallback = callback;
    [[[LEBuildingProposeForeignAid alloc] initWithCallback:@selector(proposedForeignAid:) target:self buildingId:self.id buildingUrl:self.buildingUrl planetId:bodyId resourceAmount:amount] autorelease];
}


- (void)proposeMembersOnlyColonizationTarget:(id)target callback:(SEL)callback {
    self.proposeMembersOnlyColonizationTarget = target;
    self.proposeMembersOnlyColonizationCallback = callback;
    [[[LEBuildingProposeMembersOnlyColonization alloc] initWithCallback:@selector(proposedMembersOnlyColonization:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)proposeFireBfgOn:(NSString *)bodyId reason:(NSString *)reason target:(id)target callback:(SEL)callback {
    self.proposeFireBfgTarget = target;
    self.proposeFireBfgCallback = callback;
    [[[LEBuildingProposeFireBfg alloc] initWithCallback:@selector(proposedFireBfg:) target:self buildingId:self.id buildingUrl:self.buildingUrl bodyId:bodyId reason:reason] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (void)loadedPropositions:(LEBuildingViewPropositions *)request {
    self.propositions = [self parsePropositions:request.propositions];
}


- (void)loadedLaws:(LEBuildingViewLaws *)request {
    self.laws = [self parseLaws:request.laws];
}


- (void)loadedStarsInJurisdiction:(LEBuildingGetStarsInJurisdiction *)request {
    self.starsInJurisdiction = request.stars;
}


- (void)voted:(LEBuildingCastVote *)request {
    NSString *propositionId = [Util idFromDict:request.proposition named:@"id"];
    [self.propositions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        Proposition *proposition = obj;
        if ([proposition.id isEqualToString:propositionId]) {
            [proposition parseData:request.proposition];
        }
    }];
    [self.castVoteTarget performSelector:self.castVoteCallback withObject:request];
}


- (void)proposedRepealLaw:(LEBuildingProposeRepealLaw *)request {
    [self.repealLawTarget performSelector:self.repealLawCallback withObject:request];
}


- (void)proposedWrit:(LEBuildingProposeWrit *)request {
    [self.proposeWritTarget performSelector:self.proposeWritCallback withObject:request];
}


- (void)proposedTransferStationOwnership:(LEBuildingProposeTransferStationOwnership *)request {
    [self.proposeTransferStationOwnershipTarget performSelector:self.proposeTransferStationOwnershipCallback withObject:request];
}


- (void)proposedSeizeStar:(LEBuildingProposeSeizeStar *)request {
    [self.proposeSeizeStarTarget performSelector:self.proposeSeizeStarCallback withObject:request];
}


- (void)proposedRenameStar:(LEBuildingProposeRenameStar *)request {
    [self.proposeRenameStarTarget performSelector:self.proposeRenameStarCallback withObject:request];
}


- (void)proposedBroadcastOnNetwork19:(LEBuildingProposeBroadcastOnNetwork19 *)request {
    [self.proposeBroadcastOnNetwork19Target performSelector:self.proposeBroadcastOnNetwork19Callback withObject:request];
}


- (void)proposedInductMember:(LEBuildingProposeInductMember *)request {
    [self.proposeInductMemberTarget performSelector:self.proposeInductMemberCallback withObject:request];
}


- (void)proposedExpelMember:(LEBuildingProposeExpelMember *)request {
    [self.proposeExpelMemberTarget performSelector:self.proposeExpelMemberCallback withObject:request];
}


- (void)proposedElectNewLeader:(LEBuildingProposeElectNewLeader *)request {
    [self.proposeElectNewLeaderTarget performSelector:self.proposeElectNewLeaderCallback withObject:request];
}


- (void)proposedRenameAsteroid:(LEBuildingProposeRenameAsteroid *)request {
    [self.proposeRenameAsteroidTarget performSelector:self.proposeRenameAsteroidCallback withObject:request];
}


- (void)proposedRenameUninhabited:(LEBuildingProposeRenameUninhabited *)request {
    [self.proposeRenameUninhabitedTarget performSelector:self.proposeRenameUninhabitedCallback withObject:request];
}


- (void)proposedMembersOnlyMiningRights:(LEBuildingProposeMembersOnlyColonization *)request {
    [self.proposeMembersOnlyColonizationTarget performSelector:self.proposeMembersOnlyColonizationCallback withObject:request];
}


- (void)proposedEvictMiningPlatform:(LEBuildingProposeEvictMiningPlatform *)request {
    [self.proposeEvictMiningPlatformTarget performSelector:self.proposeEvictMiningPlatformCallback withObject:request];
}


- (void)proposedTaxation:(LEBuildingProposeTaxation *)request {
    [self.proposeTaxationTarget performSelector:self.proposeTaxationCallback withObject:request];
}


- (void)proposedForeignAid:(LEBuildingProposeForeignAid *)request {
    [self.proposeForeignAidTarget performSelector:self.proposeForeignAidCallback withObject:request];
}


- (void)proposedMembersOnlyColonization:(LEBuildingProposeMembersOnlyColonization *)request {
    [self.proposeMembersOnlyColonizationTarget performSelector:self.proposeMembersOnlyColonizationCallback withObject:request];
}


- (void)proposedFireBfg:(LEBuildingProposeFireBfg *)request {
    [self.proposeFireBfgTarget performSelector:self.proposeFireBfgCallback withObject:request];
}


#pragma mark -
#pragma Private Methods

- (NSMutableArray *)parsePropositions:(NSMutableArray *)inPropositions {
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[inPropositions count]];
    [inPropositions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop){
        Proposition *proposition = [[Proposition alloc] init];
        [proposition parseData:obj];
        [tmp addObject:proposition];
        [proposition release];
    }];
    
    return tmp;
}


- (NSMutableArray *)parseLaws:(NSMutableArray *)inLaws {
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[inLaws count]];
    [inLaws enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop){
        Law *law = [[Law alloc] init];
        [law parseData:obj];
        [tmp addObject:law];
        [law release];
    }];
    
    return tmp;
}


@end
