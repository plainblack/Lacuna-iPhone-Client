//
//  TimedActivity.m
//  UniversalClient
//
//  Created by Kevin Runde on 6/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "TimedActivity.h"
#import "LEMacros.h"
#import "Util.h"


@implementation TimedActivity


@synthesize totalSeconds;
@synthesize secondsRemaining;
@synthesize startDate;
@synthesize endDate;


#pragma mark --
#pragma mark NSObject Methods

- (NSString *)description {
	return [NSString stringWithFormat:@"{ startDate:%@, endDate:%@, totalSeconds:%i, secondsRemaining:%i }",
			self.startDate, self.endDate, self.totalSeconds, self.secondsRemaining];
}


- (void)dealloc {
	self.startDate = nil;
	self.endDate = nil;
	[super dealloc];
}


#pragma mark --
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
	if (data && (id)data != [NSNull null]) {
		self.secondsRemaining = intv_([data objectForKey:@"seconds_remaining"]);
		self.startDate = [data objectForKey:@"start"];
		self.endDate = [data objectForKey:@"end"];
		self.totalSeconds = [self.endDate timeIntervalSinceDate:self.startDate];
	}
}


@end
