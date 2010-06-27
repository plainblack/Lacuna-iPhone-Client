//
//  TimedActivity.h
//  UniversalClient
//
//  Created by Kevin Runde on 6/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TimedActivity : NSObject {
	NSInteger totalSeconds;
	NSInteger secondsRemaining;
	NSDate *startDate;
	NSDate *endDate;
}


@property (nonatomic, assign) NSInteger totalSeconds;
@property (nonatomic, assign) NSInteger secondsRemaining;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;


- (void)parseData:(NSDictionary *)data;


@end
