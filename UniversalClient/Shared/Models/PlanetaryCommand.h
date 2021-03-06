//
//  PlanetaryCommand.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/14/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import	"Building.h"
#import "BuildingWithPlans.h"


@interface PlanetaryCommand : Building <BuildingWithPlans> {
}


@property (nonatomic, retain) NSDecimalNumber *nextColonyCost;

//- (void)parseData:(NSMutableDictionary *)bodyData;

@end