//
//  LEBuildingSendSpies.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingSendSpies : LERequest {
	NSString *onBodyId;
	NSString *toBodyId;
	NSString *shipId;
	NSMutableArray *spyIds;
	NSMutableDictionary *ship;
}


@property(nonatomic, retain) NSString *onBodyId;
@property(nonatomic, retain) NSString *toBodyId;
@property(nonatomic, retain) NSString *shipId;
@property(nonatomic, retain) NSMutableArray *spyIds;
@property(nonatomic, retain) NSMutableDictionary *ship;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target onBodyId:(NSString *)onBodyId toBodyId:(NSString *)toBodyId shipId:(NSString *)shipId spyIds:(NSMutableArray *)spyIds;


@end
