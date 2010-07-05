//
//  Intelligence.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@interface Intelligence : Building {
	NSInteger maxSpies;
	NSInteger numSpies;
	ResourceCost *spyTrainingCost;
}


@property (nonatomic, assign) NSInteger maxSpies;
@property (nonatomic, assign) NSInteger numSpies;
@property (nonatomic, retain) ResourceCost *spyTrainingCost;


@end
