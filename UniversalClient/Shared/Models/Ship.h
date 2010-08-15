//
//  Ship.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Ship : NSObject {
	NSString *id;
	NSString *name;
	NSString *type;
	NSString *task;
	NSDecimalNumber *speed;
	NSDecimalNumber *holdSize;
}


@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *task;
@property (nonatomic, retain) NSDecimalNumber *speed;
@property (nonatomic, retain) NSDecimalNumber *holdSize;


- (void)parseData:(NSDictionary *)spyData;


@end
