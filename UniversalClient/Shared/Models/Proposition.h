//
//  Proposition.h
//  UniversalClient
//
//  Created by Kevin Runde on 3/21/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    PROPOSITION_ROW_UNKNOWN,
    PROPOSITION_ROW_DESCRIPTION,
    PROPOSITION_ROW_STATUS,
    PROPOSITION_ROW_PROPOSED_BY,
    PROPOSITION_ROW_END_DATE,
    PROPOSITION_ROW_VOTES_NEEDED,
    PROPOSITION_ROW_VOTES_FOR,
    PROPOSITION_ROW_VOTES_AGAINST,
    PROPOSITION_ROW_MY_VOTE,
    PROPOSITION_ROW_VOTE_YES,
    PROPOSITION_ROW_VOTE_NO,
} PROPOSITION_ROW_TYPE;


@interface Proposition : NSObject {
}


@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *descriptionText;
@property (nonatomic, retain) NSDecimalNumber *votesNeeded;
@property (nonatomic, retain) NSDecimalNumber *votesYes;
@property (nonatomic, retain) NSDecimalNumber *votesNo;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSDate *dateEnds;
@property (nonatomic, retain) NSString *proposedById;
@property (nonatomic, retain) NSString *proposedByName;
@property (nonatomic, retain) NSDecimalNumber *myVote;


- (void)parseData:(NSDictionary *)data;
- (NSInteger)numPropositionRowTypes;
- (PROPOSITION_ROW_TYPE)propositionRowType:(NSInteger)rowIndex;


@end
