//
//  ResourceCost.h
//  UniversalClient
//
//  Created by Kevin Runde on 6/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ResourceCost : NSObject {
	NSInteger energy;
	NSInteger food;
	NSInteger ore;
	NSInteger time;
	NSInteger waste;
	NSInteger water;
}


@property (nonatomic, assign) NSInteger energy;
@property (nonatomic, assign) NSInteger food;
@property (nonatomic, assign) NSInteger ore;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) NSInteger waste;
@property (nonatomic, assign) NSInteger water;


- (void) parseData:(NSDictionary *)data;


@end
