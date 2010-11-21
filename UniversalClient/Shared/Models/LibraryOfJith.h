//
//  LibraryOfJith.h
//  UniversalClient
//
//  Created by Kevin Runde on 11/21/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@interface LibraryOfJith : Building {
	SEL researchSpeciesCallback;
	id researchSpeciesTarget;
}


- (void)researchSpecies:(NSString *)empireId target:(id)target callback:(SEL)callback;


@end
