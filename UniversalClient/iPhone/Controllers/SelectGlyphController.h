//
//  SelectGlyphController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class BaseTradeBuilding;
@class Glyph;


@protocol SelectGlyphControllerDelegate

- (void)glyphSelected:(Glyph *)glyph;

@end


@interface SelectGlyphController : LETableViewControllerGrouped {
	BaseTradeBuilding *baseTradeBuilding;
	id<SelectGlyphControllerDelegate> delegate;
}


@property (nonatomic, retain) BaseTradeBuilding *baseTradeBuilding;
@property (nonatomic, assign) id<SelectGlyphControllerDelegate> delegate;


+ (SelectGlyphController *) create;


@end
