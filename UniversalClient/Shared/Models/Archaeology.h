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
	NSString *itemName;
	NSInteger secondsRemaining;
}


@property (nonatomic, retain) NSMutableArray *glyphs;
@property (nonatomic, retain) NSString *itemName;
@property (nonatomic, assign) NSInteger secondsRemaining;


- (void)assembleGlyphs:(NSArray *)glyphs;
- (NSArray *)getAvailableOreTypes;
- (void)loadGlyphs;
- (void)searchForGlyph:(NSString *)oreType;


@end
