//
//  Star.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Star : NSObject {
	NSString *id;
	NSString *color;
	NSString *name;
	NSDecimalNumber *x;
	NSDecimalNumber *y;
	NSDecimalNumber *z;
}


@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *color;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSDecimalNumber *x;
@property (nonatomic, retain) NSDecimalNumber *y;
@property (nonatomic, retain) NSDecimalNumber *z;


- (void)parseData:(NSDictionary *)data;


@end
