//
//  Archaeology.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"


@protocol ArchaeologyDelegate

- (void)assembleyComplete;

@end



@interface Archaeology : Building {
	NSMutableArray *glyphs;
	NSMutableArray *availableOreTypes;
	NSString *itemName;
	NSInteger secondsRemaining;
	id<ArchaeologyDelegate> delegate;
}


@property (nonatomic, retain) NSMutableArray *glyphs;
@property (nonatomic, retain) NSMutableArray *availableOreTypes;
@property (nonatomic, retain) NSString *itemName;
@property (nonatomic, assign) NSInteger secondsRemaining;
@property (nonatomic, retain) id<ArchaeologyDelegate> delegate;


- (void)assembleGlyphs:(NSArray *)glyphs;
- (void)loadAvailableOreTypes;
- (void)loadGlyphs;
- (void)searchForGlyph:(NSString *)oreType;


@end
