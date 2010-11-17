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

- (void)assembleyComplete:(NSString *)itemName;
- (void)assembleyFailed:(NSString *)reason;

@end



@interface Archaeology : Building {
}


@property (nonatomic, retain) NSMutableArray *glyphs;
@property (nonatomic, retain) NSMutableArray *availableOreTypes;
@property (nonatomic, assign) NSInteger secondsRemaining;
@property (nonatomic, retain) id<ArchaeologyDelegate> delegate;


- (void)assembleGlyphs:(NSArray *)glyphs;
- (void)loadAvailableOreTypes;
- (void)loadGlyphs;
- (void)searchForGlyph:(NSString *)oreType;


@end
