//
//  NoLimitResource.h
//  UniversalClient
//
//  Created by Kevin Runde on 6/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NoLimitResource : NSObject {
	NSDecimalNumber *current;
	NSDecimalNumber *perHour;
	NSDecimalNumber *perSec;
}


@property (nonatomic, retain) NSDecimalNumber *current;
@property (nonatomic, retain) NSDecimalNumber* perHour;
@property (nonatomic, retain) NSDecimalNumber *perSec;


- (void)tick:(NSInteger)interval;
- (void)addToCurrent:(NSDecimalNumber *)adjustment;
- (void)subtractFromCurrent:(NSDecimalNumber *)adjustment;
- (void)parseFromData:(NSDictionary *)data withPrefix:(NSString *)prefix;




@end
