//
//  OreStorage.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@interface OreStorage : Building {
	id dumpOreTarget;
	SEL dumpOreCallback;
}


@property (nonatomic, retain) NSMutableDictionary *storedOre;


- (void)dumpOre:(NSDecimalNumber *)amount type:(NSString *)type target:(id)dumpOreTarget callback:(SEL)dumpOreCallback;


@end
