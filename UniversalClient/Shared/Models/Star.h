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
	NSInteger x;
	NSInteger y;
	NSInteger z;
}


@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *color;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;
@property (nonatomic, assign) NSInteger z;


- (void)parseData:(NSDictionary *)data;


@end
