//
//  WasteRecycling.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import	"Building.h"


@interface WasteRecycling : Building {
	BOOL canRecycle;
	NSDecimalNumber *secondsPerResource;
	NSDecimalNumber *maxResources;
	NSInteger secondsRemaining;
}


@property (nonatomic, assign) BOOL canRecycle;
@property (nonatomic, retain) NSDecimalNumber *secondsPerResource;
@property (nonatomic, retain) NSDecimalNumber *maxResources;
@property (nonatomic, assign) NSInteger secondsRemaining;


@end
