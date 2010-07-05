//
//  Network19.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@interface Network19 : Building {
	BOOL restrictingCoverage;
}


@property (nonatomic, assign) BOOL restrictingCoverage;


@end
