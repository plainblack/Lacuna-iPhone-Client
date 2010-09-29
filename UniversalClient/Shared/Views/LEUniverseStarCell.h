//
//  LEUniverseCell.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Star;


@interface LEUniverseStarCell : UIView {
	Star *star;
	UILabel *dataLabel;
	UIImageView *imageView;
	id target;
	SEL callback;
}


@property (nonatomic, retain) Star *star;


- (void)setTarget:(id)target callback:(SEL)callback;
- (void)reset;


@end
