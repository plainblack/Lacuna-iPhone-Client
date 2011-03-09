//
//  LEBuildingSendFleet.h
//  UniversalClient
//
//  Created by Kevin Runde on 3/8/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingSendFleet : LERequest {
}


@property(nonatomic, retain) NSMutableArray *shipIds;
@property(nonatomic, retain) NSString *targetBodyName;
@property(nonatomic, retain) NSString *targetBodyId;
@property(nonatomic, retain) NSString *targetStarName;
@property(nonatomic, retain) NSString *targetStarId;
@property(nonatomic, retain) NSDecimalNumber *targetX;
@property(nonatomic, retain) NSDecimalNumber *targetY;
@property(nonatomic, retain) NSMutableArray *fleet;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target shipIds:(NSMutableArray *)shipIds targetBodyName:(NSString *)targetBodyName targetBodyId:(NSString *)targetBodyId targetStarName:(NSString *)targetStarName targetStarId:(NSString *)targetStarId targetX:(NSDecimalNumber *)targetX targetY:(NSDecimalNumber *)targetY;


@end
