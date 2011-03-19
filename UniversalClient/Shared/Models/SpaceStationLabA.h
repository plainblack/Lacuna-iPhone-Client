//
//  SpaceStationLab.h
//  UniversalClient
//
//  Created by Kevin Runde on 3/18/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@interface SpaceStationLabA : Building {
}


@property(nonatomic, retain) id makePlanTaget;
@property(nonatomic, assign) SEL makePlanCallback;
@property(nonatomic, retain) NSMutableArray *types;
@property(nonatomic, retain) NSMutableArray *levels;
@property(nonatomic, retain) NSDecimalNumber *subsidyCost;
@property(nonatomic, retain) NSString *making;


- (void)makePlanType:(NSString *)type level:(NSDecimalNumber *)level target:(id)makePlanTaget callback:(SEL)makePlanCallback;


@end
