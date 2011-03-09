//
//  LEBuildingSendShip.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingSendShip : LERequest {
}


@property(nonatomic, retain) NSString *shipId;
@property(nonatomic, retain) NSString *targetBodyName;
@property(nonatomic, retain) NSString *targetBodyId;
@property(nonatomic, retain) NSString *targetStarName;
@property(nonatomic, retain) NSString *targetStarId;
@property(nonatomic, retain) NSDecimalNumber *targetX;
@property(nonatomic, retain) NSDecimalNumber *targetY;
@property(nonatomic, retain) NSMutableDictionary *ship;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target shipId:(NSString *)shipId targetBodyName:(NSString *)targetBodyName targetBodyId:(NSString *)targetBodyId targetStarName:(NSString *)targetStarName targetStarId:(NSString *)targetStarId targetX:(NSDecimalNumber *)targetX targetY:(NSDecimalNumber *)targetY;


@end
