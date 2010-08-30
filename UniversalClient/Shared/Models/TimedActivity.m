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


#pragma mark -
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


#pragma mark -
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
	if (data && (id)data != [NSNull null]) {
		self.secondsRemaining = _intv([data objectForKey:@"seconds_remaining"]) + 20;
		self.startDate = [Util date:[data objectForKey:@"start"]];
		self.endDate = [Util date:[data objectForKey:@"end"]];
		self.totalSeconds = [self.endDate timeIntervalSinceDate:self.startDate] + 20;
	}
}


- (CGFloat)progress {
	return ( (self.totalSeconds - self.secondsRemaining) / (CGFloat)self.totalSeconds);
}


- (void)tick:(NSInteger)interval {
	self.secondsRemaining -= interval;
	if (self.secondsRemaining < 0) {
		self.secondsRemaining = 0;
	}
}


@end
