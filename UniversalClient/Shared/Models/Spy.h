//
//  Spy.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/10/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Spy : NSObject {
	NSString *id;
	NSString *name;
	NSString *bodyId;
	NSString *bodyName;
	NSString *assignment;
	NSInteger level;
	NSInteger politicsExp;
	NSInteger mayhemExp;
	NSInteger theftExp;
	NSInteger intelExp;
	NSInteger defenseRating;
	NSInteger offenseRating;
	BOOL isAvailable;
	NSInteger secondsRemaining;
	NSDate *assignmentStarted;
	NSDate *assignmentEnds;
}


@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *bodyId;
@property (nonatomic, retain) NSString *bodyName;
@property (nonatomic, retain) NSString *assignment;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger politicsExp;
@property (nonatomic, assign) NSInteger mayhemExp;
@property (nonatomic, assign) NSInteger theftExp;
@property (nonatomic, assign) NSInteger intelExp;
@property (nonatomic, assign) NSInteger defenseRating;
@property (nonatomic, assign) NSInteger offenseRating;
@property (nonatomic, assign) BOOL isAvailable;
@property (nonatomic, assign) NSInteger secondsRemaining;
@property (nonatomic, retain) NSDate *assignmentStarted;
@property (nonatomic, retain) NSDate *assignmentEnds;


- (void)parseData:(NSDictionary *)spyData;
- (BOOL)tick:(NSInteger)interval;


@end
