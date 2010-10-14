//
//  Entertainment.h
//  UniversalClient
//
//  Created by Kevin Runde on 10/13/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@interface Entertainment : Building {
}


@property (nonatomic, retain) NSMutableArray *votingOptions;


- (void)loadVotingOptions;
- (void)removeVotingOptionNamed:(NSString *)votingOptionName;


@end
