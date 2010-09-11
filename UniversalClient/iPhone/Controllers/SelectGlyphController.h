//
//  SelectGlyphController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class Archaeology;
@class BaseTradeBuilding;
@class Glyph;


@protocol SelectGlyphControllerDelegate

- (void)glyphSelected:(Glyph *)glyph;

@end


@interface SelectGlyphController : LETableViewControllerGrouped {
	Archaeology *archaeology;
	BaseTradeBuilding *baseTradeBuilding;
	NSArray *filterGlyphs;
	NSMutableArray *glyphs;
	id<SelectGlyphControllerDelegate> delegate;
}


@property (nonatomic, retain) Archaeology *archaeology;
@property (nonatomic, retain) BaseTradeBuilding *baseTradeBuilding;
@property (nonatomic, retain) NSArray *filterGlyphs;
@property (nonatomic, retain) NSMutableArray *glyphs;
@property (nonatomic, assign) id<SelectGlyphControllerDelegate> delegate;


+ (SelectGlyphController *) create;


@end
