//
//  LEGetBuildables.h
//  DKTest
//
//  Created by Kevin Runde on 3/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEGetBuildables : LERequest {
	NSString *bodyId;
	NSMutableArray *buildables;
	NSNumber *x;
	NSNumber *y;
	NSString *tag;
}


@property(nonatomic, retain) NSString *bodyId;
@property(nonatomic, retain) NSMutableArray *buildables;
@property(nonatomic, retain) NSNumber *x;
@property(nonatomic, retain) NSNumber *y;
@property(nonatomic, retain) NSString *tag;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target bodyId:(NSString *)bodyId x:(NSNumber *)x y:(NSNumber *)y tag:(NSString *)tag;


@end
