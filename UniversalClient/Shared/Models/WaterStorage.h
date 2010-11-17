//
//  WaterStorage.h
//  UniversalClient
//
//  Created by Kevin Runde on 11/16/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@interface WaterStorage : Building {
	id dumpWaterTarget;
	SEL dumpWaterCallback;
}


- (void)dumpWater:(NSDecimalNumber *)amount target:(id)dumpWaterTarget callback:(SEL)dumpWaterCallback;


@end
