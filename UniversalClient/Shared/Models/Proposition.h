//
//  Proposition.h
//  UniversalClient
//
//  Created by Kevin Runde on 3/21/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Proposition : NSObject {
}


@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSDecimalNumber *votesNeeded;
@property (nonatomic, retain) NSDecimalNumber *votesYes;
@property (nonatomic, retain) NSDecimalNumber *votesNo;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSDate *dateEnds;
@property (nonatomic, retain) NSDate *proposedById;
@property (nonatomic, retain) NSDate *proposedByName;
@property (nonatomic, retain) NSDecimalNumber *myVote;


- (void)parseData:(NSDictionary *)data;


@end
