//
//  EnergyReserve.h
//  UniversalClient
//
//  Created by Kevin Runde on 11/16/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@interface EnergyReserve : Building {
	id dumpEnergyTarget;
	SEL dumpEnergyCallback;
}


- (void)dumpEnergy:(NSDecimalNumber *)amount target:(id)dumpEnergyTarget callback:(SEL)dumpEnergyCallback;


@end
