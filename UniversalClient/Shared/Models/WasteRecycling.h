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
	NSInteger secondsPerResource;
	NSInteger maxResources;
	NSInteger secondsRemaining;
}


@property (nonatomic, assign) BOOL canRecycle;
@property (nonatomic, assign) NSInteger secondsPerResource;
@property (nonatomic, assign) NSInteger maxResources;
@property (nonatomic, assign) NSInteger secondsRemaining;


@end
