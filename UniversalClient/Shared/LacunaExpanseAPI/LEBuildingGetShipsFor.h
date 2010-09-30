//
//  LEBuildingGetShipsFor.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingGetShipsFor : LERequest {
	NSString *fromBodyId;
	NSString *targetBodyName;
	NSString *targetBodyId;
	NSString *targetStarName;
	NSString *targetStarId;
	NSDecimalNumber *targetX;
	NSDecimalNumber *targetY;
	NSMutableArray *incoming;
	NSMutableArray *available;
	NSMutableArray *unavailabe;
	NSMutableArray *miningPlatforms;
}


@property(nonatomic, retain) NSString *fromBodyId;
@property(nonatomic, retain) NSString *targetBodyName;
@property(nonatomic, retain) NSString *targetBodyId;
@property(nonatomic, retain) NSString *targetStarName;
@property(nonatomic, retain) NSString *targetStarId;
@property(nonatomic, retain) NSDecimalNumber *targetX;
@property(nonatomic, retain) NSDecimalNumber *targetY;
@property(nonatomic, retain) NSMutableArray *incoming;
@property(nonatomic, retain) NSMutableArray *available;
@property(nonatomic, retain) NSMutableArray *unavailabe;
@property(nonatomic, retain) NSMutableArray *miningPlatforms;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target fromBodyId:(NSString *)fromBodyId targetBodyName:(NSString *)targetBodyName targetBodyId:(NSString *)targetBodyId targetStarName:(NSString *)targetStarName targetStarId:(NSString *)targetStarId targetX:(NSDecimalNumber *)targetX targetY:(NSDecimalNumber *)targetY;


@end
