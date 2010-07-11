//
//  ResourceStorage.h
//  UniversalClient
//
//  Created by Kevin Runde on 6/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ResourceStorage : NSObject {
	NSInteger energy;
	NSInteger food;
	NSInteger ore;
	NSInteger waste;
	NSInteger water;
	BOOL hasStorage;
}


@property (nonatomic, assign) NSInteger energy;
@property (nonatomic, assign) NSInteger food;
@property (nonatomic, assign) NSInteger ore;
@property (nonatomic, assign) NSInteger waste;
@property (nonatomic, assign) NSInteger water;
@property (nonatomic, assign) BOOL hasStorage;


- (void)parseData:(NSDictionary *)data;


@end
