//
//  LEBodyMapCell.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MapBuilding;
@class Body;


@interface LEBodyMapCell : UIView {
	id target;
	SEL callback;
}


@property (nonatomic, assign) BOOL showOverlay;
@property (nonatomic, retain) NSDecimalNumber *buildingX;
@property (nonatomic, retain) NSDecimalNumber *buildingY;
@property (nonatomic, retain) MapBuilding *mapBuilding;


- (void)target:(id)target callback:(SEL)callback;


@end
