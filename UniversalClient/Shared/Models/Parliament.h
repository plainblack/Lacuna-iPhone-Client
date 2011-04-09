//
//  Parliament.h
//  UniversalClient
//
//  Created by Kevin Runde on 3/21/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Module.h"


@interface Parliament : Module {
}


@property (nonatomic, retain) NSMutableArray *propositions;
@property (nonatomic, retain) NSMutableArray *laws;
@property (nonatomic, retain) id castVoteTarget;
@property (nonatomic, assign) SEL castVoteCallback;


- (void)loadPropositions;
- (void)loadLaws;
- (void)castVote:(BOOL)vote propositionId:(NSString *)propositionId target:(id)target callback:(SEL)callback;


@end
