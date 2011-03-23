//
//  Proposition.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/21/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "Proposition.h"
#import "LEMacros.h"
#import	"Util.h"


@implementation Proposition


@synthesize id;
@synthesize name;
@synthesize descriptionText;
@synthesize votesNeeded;
@synthesize votesYes;
@synthesize votesNo;
@synthesize status;
@synthesize dateEnds;
@synthesize proposedById;
@synthesize proposedByName;
@synthesize myVote;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.id = nil;
	self.name = nil;
	self.descriptionText = nil;
	self.votesNeeded = nil;
	self.votesYes = nil;
	self.votesNo = nil;
	self.status = nil;
	self.dateEnds = nil;
	self.proposedById = nil;
	self.proposedByName = nil;
	self.myVote = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, name:%@, description:%@, votesNeeded:%@, votesYes:%@, votesNo:%@, status:%@, dateEnds:%@, proposedById:%@, proposedByName:%@, myVote:%@",
        self.id, self.name, self.descriptionText, self.votesNeeded, self.votesYes, self.votesNo, self.status, self.dateEnds, self.proposedById, self.proposedByName, self.myVote];
}


#pragma mark -
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
	self.id = [Util idFromDict:data named:@"id"];
	self.name = [data objectForKey:@"name"];
	self.descriptionText = [data objectForKey:@"description"];
	self.votesNeeded = [Util asNumber:[data objectForKey:@"votes_needed"]];
	self.votesYes = [Util asNumber:[data objectForKey:@"votes_yes"]];
	self.votesNo = [Util asNumber:[data objectForKey:@"votes_no"]];
	self.status = [data objectForKey:@"status"];
	self.dateEnds = [Util date:[data objectForKey:@"date_ends"]];
    NSMutableDictionary *proposedByData = [data objectForKey:@"proposed_by"];
	self.proposedById = [proposedByData objectForKey:@"id"];
	self.proposedByName = [proposedByData objectForKey:@"name"];
	self.myVote = [Util asNumber:[data objectForKey:@"my_vote"]];
    NSLog(@"Data: %@", data);
    NSLog(@"Proposition: %@", self);
}


- (NSInteger)numPropositionRowTypes {
    if (isNotNull(self.myVote)) {
        return 6;
    } else {
        return 7;
    }
}


- (PROPOSITION_ROW_TYPE)propositionRowType:(NSInteger)rowIndex {
    switch (rowIndex) {
        case 0:
            return PROPOSITION_ROW_DESCRIPTION;
            break;
        case 1:
            return PROPOSITION_ROW_STATUS;
            break;
        case 2:
            return PROPOSITION_ROW_PROPOSED_BY;
            break;
        case 3:
            return PROPOSITION_ROW_END_DATE;
            break;
        case 4:
            return PROPOSITION_ROW_VOTES;
            break;
        case 5:
            if (isNotNull(self.myVote)) {
                return PROPOSITION_ROW_MY_VOTE;
            } else {
                return PROPOSITION_ROW_VOTE_YES;
            }
            break;
        case 6:
            if (isNotNull(self.myVote)) {
                return PROPOSITION_ROW_UNKNOWN;
            } else {
                return PROPOSITION_ROW_VOTE_NO;
            }
            break;
        default:
            return PROPOSITION_ROW_UNKNOWN;
            break;
    }
}


@end
