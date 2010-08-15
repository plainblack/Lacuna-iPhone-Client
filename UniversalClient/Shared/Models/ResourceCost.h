//
//  ResourceCost.h
//  UniversalClient
//
//  Created by Kevin Runde on 6/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ResourceCost : NSObject {
	NSDecimalNumber *energy;
	NSDecimalNumber *food;
	NSDecimalNumber *ore;
	NSDecimalNumber *time;
	NSDecimalNumber *waste;
	NSDecimalNumber *water;
}


@property (nonatomic, retain) NSDecimalNumber *energy;
@property (nonatomic, retain) NSDecimalNumber *food;
@property (nonatomic, retain) NSDecimalNumber *ore;
@property (nonatomic, retain) NSDecimalNumber *time;
@property (nonatomic, retain) NSDecimalNumber *waste;
@property (nonatomic, retain) NSDecimalNumber *water;


- (void) parseData:(NSDictionary *)data;


@end
