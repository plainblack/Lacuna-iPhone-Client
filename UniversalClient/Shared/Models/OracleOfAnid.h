//
//  OracleOfAnid.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/23/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@class Star;


@interface OracleOfAnid : Building {
}


@property(nonatomic, retain) Star *star;
@property(nonatomic, retain) NSMutableArray *bodies;


- (void)loadStar:(NSString *)starId;


@end
