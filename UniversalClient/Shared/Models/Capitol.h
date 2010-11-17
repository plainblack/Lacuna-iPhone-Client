//
//  Capitol.h
//  UniversalClient
//
//  Created by Kevin Runde on 11/16/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@interface Capitol : Building {
	id renameEmpireTarget;
	SEL renameEmpireCallback;
}


@property (nonatomic, retain) NSDecimalNumber *renameEmpireCost;


- (void)renameEmpire:(NSString *)newEmpireName target:(id)renameEmpireTarget callback:(SEL)renameEmpireCallback;


@end
