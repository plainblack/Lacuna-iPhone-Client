//
//  HallsOfVrbansk.h
//  UniversalClient
//
//  Created by Kevin Runde on 11/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@interface HallsOfVrbansk : Building {
	SEL getUpgradableBuildingsCallback;
	id getUpgradableBuildingsTarget;
	SEL upgradeBuildingCallback;
	id upgradeBuildingTarget;
}


- (void)getUpgradableBuildingsTarget:(id)target callback:(SEL)callback;
- (void)upgradeBuilding:(NSString *)upgradeBuildingId target:(id)target callback:(SEL)callback;


@end
