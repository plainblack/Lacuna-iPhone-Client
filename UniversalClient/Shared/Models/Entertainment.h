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
	id duckQuackTarget;
	SEL duckQuackCallback;
}


@property (nonatomic, retain) NSMutableArray *votingOptions;
@property (nonatomic, retain) NSDecimalNumber *ducksQuacked;


- (void)loadVotingOptions;
- (void)removeVotingOptionNamed:(NSString *)votingOptionName;
- (void)quackDuck:(id)target callback:(SEL)callback;


@end
