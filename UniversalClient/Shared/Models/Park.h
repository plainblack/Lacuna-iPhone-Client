//
//  Park.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@interface Park : Building {
	BOOL canThrowParty;
	NSInteger secondsRemaining;
	NSDecimalNumber *happinessFromParty;
}


@property (nonatomic, assign) BOOL canThrowParty;
@property (nonatomic, assign) NSInteger secondsRemaining;
@property (nonatomic, retain) NSDecimalNumber *happinessPerParty;


@end
