//
//  BuildingWithPlans.h
//  UniversalClient
//
//  Created by Kevin Runde on 3/12/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol BuildingWithPlans <NSObject>


@property (nonatomic, retain) NSMutableArray *plans;


- (void)loadPlans;


@end
