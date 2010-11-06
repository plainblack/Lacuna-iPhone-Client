//
//  Mission.h
//  UniversalClient
//
//  Created by Kevin Runde on 11/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Mission : NSObject {
}


@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSDecimalNumber *maxUniversityLevel;
@property (nonatomic, retain) NSDate *datePosted;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *missionDescription;
@property (nonatomic, retain) NSMutableArray *objectives;
@property (nonatomic, readonly) NSString *objectivesAsText;
@property (nonatomic, retain) NSMutableArray *rewards;
@property (nonatomic, readonly) NSString *rewardsAsText;


- (void)parseData:(NSDictionary *)data;


@end
