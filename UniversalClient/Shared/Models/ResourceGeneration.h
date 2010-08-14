//
//  BuildingResources.h
//  UniversalClient
//
//  Created by Kevin Runde on 6/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ResourceGeneration : NSObject {
	NSDecimalNumber *energy;
	NSDecimalNumber *food;
	NSDecimalNumber *happiness;
	NSDecimalNumber *ore;
	NSDecimalNumber *waste;
	NSDecimalNumber *water;
}


@property (nonatomic, retain) NSDecimalNumber *energy;
@property (nonatomic, retain) NSDecimalNumber *food;
@property (nonatomic, retain) NSDecimalNumber *happiness;
@property (nonatomic, retain) NSDecimalNumber *ore;
@property (nonatomic, retain) NSDecimalNumber *waste;
@property (nonatomic, retain) NSDecimalNumber *water;


- (void) parseData:(NSDictionary *)data;


@end
