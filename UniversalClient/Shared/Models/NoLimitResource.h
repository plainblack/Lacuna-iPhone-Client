//
//  NoLimitResource.h
//  UniversalClient
//
//  Created by Kevin Runde on 6/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NoLimitResource : NSObject {
	NSNumber *current;
	NSInteger perHour;
	NSNumber *perSec;
	NSDate *lastTick;
}


@property (nonatomic, retain) NSNumber *current;
@property (nonatomic, assign) NSInteger perHour;
@property (nonatomic, retain) NSNumber *perSec;
@property (nonatomic, retain) NSDate *lastTick;


- (void)tick:(NSInteger)interval;
- (void)addToCurrent:(NSNumber *)adjustment;
- (void)subtractFromCurrent:(NSNumber *)adjustment;


+ (NoLimitResource *)createFromData:(NSDictionary *)data withPrefix:(NSString *)prefix;


@end
