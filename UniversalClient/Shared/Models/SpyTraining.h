//
//  SpyTraining.h
//  UniversalClient
//
//  Created by Kevin Runde on 5/30/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"

@interface SpyTraining : Building {
}


@property (nonatomic, retain) NSMutableArray *spies;
@property(nonatomic, retain) id trainSpyTaget;
@property(nonatomic, assign) SEL trainSpyCallback;


- (void)trainSpy:(NSString *)spyId target:(id)taget callback:(SEL)callback;


@end
