//
//  StoredResource.h
//  UniversalClient
//
//  Created by Kevin Runde on 6/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StoredResource : NSObject {
	NSDecimalNumber *current;
	NSDecimalNumber *max;
	NSDecimalNumber *perHour;
	NSDecimalNumber *perSec;
}


@property (nonatomic, retain) NSDecimalNumber *current;
@property (nonatomic, retain) NSDecimalNumber *max;
@property (nonatomic, retain) NSDecimalNumber *perHour;
@property (nonatomic, retain) NSDecimalNumber *perSec;


- (NSDecimalNumber *)tick:(NSInteger)interval;
- (void)parseFromData:(NSDictionary *)data withPrefix:(NSString *)prefix;


@end
