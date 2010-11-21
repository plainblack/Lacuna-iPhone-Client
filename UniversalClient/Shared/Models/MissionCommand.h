//
//  MissionCommand.h
//  UniversalClient
//
//  Created by Kevin Runde on 10/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@class Mission;


@interface MissionCommand : Building {
	id completeTarget;
	SEL completeCallback;
	id skipTarget;
	SEL skipCallback;
}


@property (nonatomic, retain) NSMutableArray *missions;


- (void)completeMission:(Mission *)mission target:(id)target callback:(SEL)callback;
- (void)loadMissions;
- (void)skipMission:(Mission *)mission target:(id)target callback:(SEL)callback;


@end
