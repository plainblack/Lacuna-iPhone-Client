//
//  LEUniverseCell.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Star;


@interface LEUniverseCell : UIView {
	Star *star;
	UILabel *dataLabel;
	UIImageView *imageView;
}


- (void)setStar:(Star *)star;
- (void)reset;


@end
