//
//  ThemePark.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@interface ThemePark : Building {
}


@property (nonatomic, assign) BOOL canOperate;
@property (nonatomic, retain) NSDecimalNumber *foodTypeCount;
@property (nonatomic, retain) NSString *reason;


@end
