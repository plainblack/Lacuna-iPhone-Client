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
	id target;
	SEL callback;
}


@property (nonatomic, retain) Body *body;


- (void)setTarget:(id)target callback:(SEL)callback;
- (void)reset;


@end
