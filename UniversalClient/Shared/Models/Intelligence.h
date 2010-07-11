//
//  Intelligence.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@class Spy;


@interface Intelligence : Building {
	NSInteger maxSpies;
	NSInteger numSpies;
	ResourceCost *spyTrainingCost;
	NSMutableArray *spies;
	NSArray *possibleAssignments;
	NSDate *spiesUpdated;
}


@property (nonatomic, assign) NSInteger maxSpies;
@property (nonatomic, assign) NSInteger numSpies;
@property (nonatomic, retain) ResourceCost *spyTrainingCost;
@property (nonatomic, retain) NSMutableArray *spies;
@property (nonatomic, retain) NSArray *possibleAssignments;
@property (nonatomic, retain) NSDate *spiesUpdated;


- (void)loadSpies;
- (void)burnSpy:(Spy *)spy;
- (void)spy:(Spy *)spy rename:(NSString *)newName;
- (void)spy:(Spy *)spy assign:(NSString *)assignment;


@end
