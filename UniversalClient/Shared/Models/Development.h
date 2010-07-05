//
//  Development.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@interface Development : Building {
	NSInteger costToSubsidize;
	NSMutableArray *buildQueue;
}


@property (nonatomic, assign) NSInteger costToSubsidize;
@property (nonatomic, retain) NSMutableArray *buildQueue;


@end
