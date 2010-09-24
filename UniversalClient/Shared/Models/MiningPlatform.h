//
//  MiningPlatform.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/1/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MiningPlatform : NSObject {
	NSString *id;
	NSString *asteroidId;
	NSString *asteroidName;
	NSString *asteroidImageName;
	NSDecimalNumber *asteroidX;
	NSDecimalNumber *asteroidY;
	NSMutableDictionary *oresPerHour;
	NSDecimalNumber *shippingCapacity;
}


@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *asteroidId;
@property (nonatomic, retain) NSString *asteroidName;
@property (nonatomic, retain) NSString *asteroidImageName;
@property (nonatomic, retain) NSDecimalNumber *asteroidX;
@property (nonatomic, retain) NSDecimalNumber *asteroidY;
@property (nonatomic, retain) NSMutableDictionary *oresPerHour;
@property (nonatomic, retain) NSDecimalNumber *shippingCapacity;


- (void)parseData:(NSDictionary *)data;


@end
