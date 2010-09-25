//
//  LEStatsFineEmpireRank.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEStatsFindEmpireRank : LERequest {
	NSString *sortBy;
	NSString *empireName;
	NSMutableArray *empires;
}


@property (nonatomic, retain) NSString *sortBy;
@property (nonatomic, retain) NSString *empireName;
@property (nonatomic, retain) NSMutableArray *empires;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target sortBy:(NSString *)sortBy empireName:(NSString *)empireName;


@end
