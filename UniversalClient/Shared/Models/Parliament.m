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
#import "LETableViewCellButton.h"
#import "LEBuildingViewPropositions.h"
#import "LEBuildingCastVote.h"
#import "Proposition.h"
#import "ViewPropositionsController.h"


@interface Parliament(PrivateMethods)


- (NSMutableArray *)parsePropositions:(NSMutableArray *)propositions;


@end


@implementation Parliament


@synthesize propositions;
@synthesize castVoteTarget;
@synthesize castVoteCallback;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
    self.propositions = nil;
    self.castVoteTarget = nil;
    self.castVoteCallback = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Overriden Building Methods

- (void)generateSections {
	NSMutableDictionary *actionSection = _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_PROPOSITIONS]), @"rows");
    
	self.sections = _array([self generateProductionSection], actionSection, [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_PROPOSITIONS:
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


- (void)castVote:(BOOL)vote propositionId:(NSString *)propositionId target:(id)target callback:(SEL)callback {
    self.castVoteTarget = target;
    self.castVoteCallback = callback;
    [[[LEBuildingCastVote alloc] initWithCallback:@selector(voted:) target:self buildingId:self.id buildingUrl:self.buildingUrl propositionId:propositionId vote:vote] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (void)loadedPropositions:(LEBuildingViewPropositions *)request {
    self.propositions = [self parsePropositions:request.propositions];
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



@end
