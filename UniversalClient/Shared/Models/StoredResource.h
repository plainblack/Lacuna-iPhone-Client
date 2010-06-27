//
//  StoredResource.h
//  UniversalClient
//
//  Created by Kevin Runde on 6/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StoredResource : NSObject {
	NSNumber *current;
	NSInteger max;
	NSInteger perHour;
	NSNumber *perSec;
	NSDate *lastTick;
}


@property (nonatomic, retain) NSNumber *current;
@property (nonatomic, assign) NSInteger max;
@property (nonatomic, assign) NSInteger perHour;
@property (nonatomic, retain) NSNumber *perSec;
@property (nonatomic, retain) NSDate *lastTick;


- (NSNumber *)tick:(NSTimeInterval)interval;


+ (StoredResource *)createFromData:(NSDictionary *)data withPrefix:(NSString *)prefix;


@end
