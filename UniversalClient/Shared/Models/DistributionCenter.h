//
//  DistributionCenter.h
//  UniversalClient
//
//  Created by Kevin Runde on 3/15/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@interface DistributionCenter : Building {
}


@property(nonatomic, retain) id getStoredResourcesTaget;
@property(nonatomic, assign) SEL getStoredResourcesCallback;
@property(nonatomic, retain) id reserverTaget;
@property(nonatomic, assign) SEL reserverCallback;
@property(nonatomic, retain) id releaseReserverTaget;
@property(nonatomic, assign) SEL releaseReserverCallback;
@property(nonatomic, assign) NSInteger secondsRemaining;
@property(nonatomic, assign) BOOL can;
@property(nonatomic, retain) NSDecimalNumber *maxReserverDuration;
@property(nonatomic, retain) NSDecimalNumber *maxReserverSize;
@property(nonatomic, retain) NSMutableArray *resources;


- (void)getStoredResourcesTarget:(id)getStoredResourcesTaget callback:(SEL)getStoredResourcesCallback;
- (void)reserve:(NSMutableArray *)reserveResources target:(id)reserverTaget callback:(SEL)reserverCallback;
- (void)releaseReserveTarget:(id)releaseReserverTaget callback:(SEL)releaseReserverCallback;


@end
