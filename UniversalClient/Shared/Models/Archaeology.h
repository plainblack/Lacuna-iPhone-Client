//
//  Archaeology.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"

@interface Archaeology : Building {
	NSMutableArray *glyphs;
}


@property (nonatomic, retain) NSMutableArray *glyphs;


@end
