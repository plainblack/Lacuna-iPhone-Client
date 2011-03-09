//
//  Spy.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/10/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Spy : NSObject {
}


@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *bodyId;
@property (nonatomic, retain) NSString *bodyName;
@property (nonatomic, retain) NSString *assignment;
@property (nonatomic, retain) NSDecimalNumber *level;
@property (nonatomic, retain) NSDecimalNumber *politicsExp;
@property (nonatomic, retain) NSDecimalNumber *mayhemExp;
@property (nonatomic, retain) NSDecimalNumber *theftExp;
@property (nonatomic, retain) NSDecimalNumber *intelExp;
@property (nonatomic, retain) NSDecimalNumber *defenseRating;
@property (nonatomic, retain) NSDecimalNumber *offenseRating;
@property (nonatomic, assign) BOOL isAvailable;
@property (nonatomic, assign) NSInteger secondsRemaining;
@property (nonatomic, retain) NSDate *assignmentStarted;
@property (nonatomic, retain) NSDate *assignmentEnds;
@property (nonatomic, retain) NSMutableArray *possibleAssignments;
@property (nonatomic, retain) NSDecimalNumber *numOffensiveMissions;
@property (nonatomic, retain) NSDecimalNumber *numDefensiveMissions;


- (void)parseData:(NSDictionary *)spyData;
- (BOOL)tick:(NSInteger)interval;


@end
