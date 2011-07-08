//
//  GeneticsLab.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@interface GeneticsLab : Building {
	id prepareExperimentTarget;
	SEL prepareExperimentCallback;
	id changeNameTarget;
	SEL changeNameCallback;
	id runExperimentTarget;
	SEL runExperimentCallback;
}


- (void)prepareExperiments:(id)target callback:(SEL)callback;
- (void)changeName:(NSString *)speciesName description:(NSString *)description forTarger:(id)target callback:(SEL)callback;
- (void)runExperimentWithSpy:(NSString *)spyId affinity:(NSString *)affinity target:(id)target callback:(SEL)callback;


@end
