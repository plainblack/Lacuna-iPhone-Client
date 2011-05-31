//
//  PoliceStation.h
//  UniversalClient
//
//  Created by Kevin Runde on 5/8/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpySecurity.h"
#import "ShipIntel.h"
#import "Module.h"

@interface PoliceStation : Module <SpySecurity, ShipIntel> {
    
}

@end
