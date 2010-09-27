//
//  LEUniverseHabitablePlanetCell.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Body;


@interface LEUniverseBodyCell : UIView {
	Body *body;
	UIImageView *imageViewBody;
	UIImageView *imageViewAlignmentRing;
}


- (void)setBody:(Body *)body;
- (void)reset;


@end
