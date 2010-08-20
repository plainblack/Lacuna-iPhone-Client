//
//  Plan.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Plan : NSObject {
	NSString *id;
	NSString *name;
	NSDecimalNumber *buildLevel;
	NSDecimalNumber *extraBuildLevel;
}


@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSDecimalNumber *buildLevel;
@property (nonatomic, retain) NSDecimalNumber *extraBuildLevel;


- (void)parseData:(NSDictionary *)data;


@end
