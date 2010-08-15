//
//  ResourceStorage.h
//  UniversalClient
//
//  Created by Kevin Runde on 6/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ResourceStorage : NSObject {
	NSDecimalNumber *energy;
	NSDecimalNumber *food;
	NSDecimalNumber *ore;
	NSDecimalNumber *waste;
	NSDecimalNumber *water;
	BOOL hasStorage;
}


@property (nonatomic, retain) NSDecimalNumber *energy;
@property (nonatomic, retain) NSDecimalNumber *food;
@property (nonatomic, retain) NSDecimalNumber *ore;
@property (nonatomic, retain) NSDecimalNumber *waste;
@property (nonatomic, retain) NSDecimalNumber *water;
@property (nonatomic, assign) BOOL hasStorage;


- (void)parseData:(NSDictionary *)data;


@end
